//
//  MoFavorisViewController.m
//  rapt2
//
//  Created by Moufasa on 06/07/13.
//  Copyright (c) 2013 Moufasa. All rights reserved.
//

#import "MoFavorisViewController.h"
#import "SWRevealViewController.h"

@interface MoFavorisViewController ()

@end

@implementation MoFavorisViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    _sidebarButton.tintColor = [UIColor colorWithWhite:0.96f alpha:0.2f];

    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    // Add pan gesture to hide the sidebar
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    

}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
    NSError * error = nil; //hack error
    NSManagedObjectContext * context = [self managedObjectContext];
    NSFetchRequest * request = [[NSFetchRequest alloc]init];
    NSEntityDescription * entity = [NSEntityDescription entityForName:@"Ligne" inManagedObjectContext:context];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"inBase == 1"];
    [request setPredicate:predicate];
    [request setEntity:entity];
    
    //recuperer withFetchAll
    //NSError * error = nil; //hack error

    self.lignes = (NSMutableArray *)[context executeFetchRequest:request error:&error];
    //Station * stationInBase;
    //NSInteger currentLigneIndex;
    
    for(Ligne* currentLigne in self.lignes){
        NSInteger indexLigne = [self.lignes indexOfObject:currentLigne];
        for (Station * currentStation in currentLigne.stations) {
            
            NSLog(@"inBase : %d",currentStation.inBase);
//            currentLigne.inBase = 0;
            if (currentStation.inBase != 0) {
                //[currentLigne.stations removeObject:currentStation];
                [[self.lignes objectAtIndex:indexLigne] setStations:[NSSet setWithObject:currentStation]];
                //stationInBase = currentStation;
                //currentLigneIndex = indexLigne;
                //NSLog(@"station %@ inBase ? %d",currentStation.name,(int) currentStation.inBase);
            }
            else{
                NSLog(@"On est dans le ELSE");
            }
        }
        //[[self.lignes objectAtIndex:currentLigneIndex] setStations:[NSSet setWithObject:stationInBase]];
    }
    
    
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
      return [self.lignes count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if([self.lignes count] != 0){
        Ligne * ligne = [self.lignes objectAtIndex:indexPath.row];
        Station * station = [[ligne.stations allObjects] objectAtIndex:0];
        //NSArray * stationsTmp = [ligne.stations allObjects];
        
        NSLog(@"Ligne %@ : il y a %d stations liés avec inbase à %d",ligne.name, [[ligne.stations allObjects] count], (int) station.inBase);
        cell.detailTextLabel.text = [NSString stringWithFormat:@"RER %@",ligne.name];
        cell.textLabel.text = [station.name stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    }
    else{
        cell.textLabel.text = @"Aucun favoris";
        cell.detailTextLabel.text = @"";
    }
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [tableView beginUpdates];

        // Delete the row from the data source
        //NSManagedObjectID * lignesId = [[self.lignes objectAtIndex:indexPath.row] objectID];

        
        //Ligne * ligne = (Ligne *)[[self managedObjectContext] objectWithID:lignesId];
        //[self.lignes removeObjectAtIndex:indexPath.row];
        [[self managedObjectContext] deleteObject:[self.lignes objectAtIndex:indexPath.row]];
        
        //[self.lignes removeObjectAtIndex:indexPath.row];
        NSMutableArray *array = [self.lignes mutableCopy];
        [array removeObjectAtIndex:indexPath.row];
        self.lignes = array;
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        NSManagedObjectContext * context = [(MoAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
        [context save:nil];
        
        [tableView reloadData];
        [tableView endUpdates];

    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return NO;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"horaire"]) {
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        //MoListHoraireViewController *destViewController = segue.destinationViewController;
//        NSArray * lignes = [self.lignes allObjects];
        Ligne * ligne = [self.lignes objectAtIndex:indexPath.row];
        [segue.destinationViewController setLigne:(Ligne *) ligne];
         //NSArray * stations = [ligne.stations allObjects];
         //[segue.destinationViewController setStation:[stations objectAtIndex:0]];
    }
}

@end
