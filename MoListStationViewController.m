//
//  MoListStationViewController.m
//  rapt2
//
//  Created by Moufasa on 06/07/13.
//  Copyright (c) 2013 Moufasa. All rights reserved.
//

#import "MoListStationViewController.h"

@interface MoListStationViewController ()

@end

@implementation MoListStationViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    //NSLog(@"ViewDidLoad : %@",self.ligne.name);

}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.ligne = [MoApiFetcher getForcedStationForLigne:self.ligne];
    NSSortDescriptor *nameDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    //    self.ligne.stations = [NSSet setWithArray:[self.ligne.stations sortedArrayUsingDescriptors:[NSArray arrayWithObject:nameDescriptor]]];
    self.stations = (NSMutableArray *)[self.ligne.stations sortedArrayUsingDescriptors:[NSArray arrayWithObject:nameDescriptor]];

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
    return [self.ligne.stations count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *CellIdentifier = @"CellStation";
//    static NSString * CellIdentifierSave = @"CellStationSave";
//    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
//    if(cell == nil){
//        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierSave forIndexPath:indexPath];
//    }

    static NSString *CellIdentifier = @"CellStation";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier: CellIdentifier];
    
    if (cell==nil) {
        static NSString *CellIdentifier = @"CellStationSave";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    }
    else{
        static NSString *CellIdentifier = @"CellStation";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    }
    
    //NSArray * stations = [self.ligne.stations allObjects];
    Station * station = [self.stations objectAtIndex:indexPath.row];
    cell.textLabel.text = [station.name stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
    static NSString * CellIdentifierSave = @"CellStationSave";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierSave];
    if(cell != nil){
        NSError * error = nil; //hack error
        NSManagedObjectContext * context = [(MoAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
        self.ligne.inBase = YES;
       // [[self.stations objectAtIndex:indexPath.row] setInBase:YES]; //indexPath.row
        Station * currentStation = [self.stations objectAtIndex:indexPath.row];
        currentStation.inBase = YES;
        self.ligne.stations = [NSSet setWithObject:currentStation];
        //[lorem addStationsObject:station];
        //NSArray * tmp = [self.ligne.stations allObjects];
        //NSLog(@"on va sauvegardé : ligne %@ station : %@",self.ligne.name,[(Station *)[tmp objectAtIndex:indexPath.row] name]);
        NSLog(@"On sauvegarde %d stations",[self.ligne.stations count]);
        [context save:&error];
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Sauvegarde"
                              message:[[currentStation.name stringByReplacingOccurrencesOfString:@"+" withString:@" "] stringByAppendingString:@" a été sauvegardée."]
                              delegate:nil
                              cancelButtonTitle:@"Confirmer"
                              otherButtonTitles:nil];
        [alert show];
     
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"horaire"]) {
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        //MoListHoraireViewController *destViewController = segue.destinationViewController;
        NSArray * stations = [self.ligne.stations allObjects];
        [segue.destinationViewController setStation:(Station *)[stations objectAtIndex:indexPath.row]];
        [segue.destinationViewController setLigne:(Ligne *) self.ligne];
    }   
}

@end
