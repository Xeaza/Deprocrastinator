//
//  ViewController.m
//  Deprocrastinator
//
//  Created by Taylor Wright-Sanson on 10/6/14.
//  Copyright (c) 2014 Taylor Wright-Sanson. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *addToDoItemTextField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property NSMutableArray *checkedIndexes;
@property NSMutableArray *todoListArray;
@property NSIndexPath *indexToDelete;
@property NSArray *checkedItemsArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //self.checkedItemsArray = @[@{@"itemName" : @"Sky Dive from Sears Tower", @"itemIndex" : @0}];
    //NSLog(@"%@", [[self.checkedItemsArray objectAtIndex:0] valueForKey:@"itemName"]);

    self.indexToDelete = [[NSIndexPath alloc] init];
    self.todoListArray = [NSMutableArray arrayWithObjects:@"Sky Dive from Sears Tower", @"Sky Dive from Sears Tower", @"Sky Dive from Sears Tower", @"Sky Dive from Sears Tower", @"Sky Dive from Sears Tower", @"Sky Dive from Sears Tower", @"Sky Dive from Sears Tower", @"Sky Dive from Sears Tower", @"Sky Dive from Sears Tower", @"Sky Dive from Sears Tower", @"Sky Dive from Sears Tower", @"Sky Dive from Sears Tower", @"Sky Dive from Sears Tower", @"Sky Dive from Sears Tower", @"Eat Cake", @"Tickle a Dragon", @"Don't Panic", nil];

    // TODO add array that keeps track of which cells are checked
    // TODO add array that keeps track of which cells have their text color different
    // Use these arrays to reset the cells to have the correct accessories when they are reused.
    
    self.checkedIndexes = [NSMutableArray arrayWithCapacity:self.todoListArray.count];
    // Created array of 0s indicating that no cells have been selected (i.e. no checkmark added)
    for (int i = 0; i < self.todoListArray.count; i++)
    {
        [self.checkedIndexes addObject:[NSNumber numberWithBool:NO]];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.todoListArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSString *cellIdentifier = @"toDoListCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:cellIdentifier];
    }

    //Refresh acessory for cell when tableview have many cells and reuse identifier
    /*if([self.selectedIndexes objectAtIndex:indexPath.row]){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }*/

    cell.textLabel.text = [self.todoListArray objectAtIndex:indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    //cell.accessoryType = UITableViewCellAccessoryCheckmark;
   [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (cell.accessoryType == UITableViewCellAccessoryNone)
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        // Update checkmarked buttson list
        [self.checkedIndexes replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:YES]];

    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [self.checkedIndexes removeObject:indexPath];
        // Update checkmarked buttson list
        [self.checkedIndexes replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:NO]];
    }
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {


}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self showDeleteCheckAlert: indexPath];
    }
}

- (IBAction)onAddButtonPressed:(id)sender {
    NSString *usersText = self.addToDoItemTextField.text;
    [self.todoListArray addObject:usersText];
    [self.checkedIndexes addObject:[NSNumber numberWithBool:NO]];
    [self.tableView reloadData];


    self.addToDoItemTextField.text = nil;
    [self.addToDoItemTextField resignFirstResponder];
}
- (IBAction)onEditButtonPressed:(UIButton *)editButton {
    if ([editButton.titleLabel.text isEqualToString:@"Edit"]) {
        [editButton setTitle:@"Done" forState:UIControlStateNormal];
        // Add Logic to delete a rows

        [self.tableView setEditing:YES animated:YES];

    } else {
        [editButton setTitle:@"Edit" forState:UIControlStateNormal];
        [self.tableView setEditing:NO animated:YES];

    }
}

- (IBAction)onSwipeGesture:(UISwipeGestureRecognizer *)swipeGesture {
    CGPoint point = [swipeGesture locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];

    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if (cell.textLabel.textColor == [UIColor blackColor]) {
        cell.textLabel.textColor = [UIColor greenColor];
    }
    else if (cell.textLabel.textColor == [UIColor greenColor]){
        cell.textLabel.textColor = [UIColor yellowColor];
    }
    else if (cell.textLabel.textColor == [UIColor yellowColor]) {
        cell.textLabel.textColor = [UIColor redColor];
    }
    else if (cell.textLabel.textColor == [UIColor redColor]) {
        cell.textLabel.textColor = [UIColor blackColor];
    }
}

- (void)showDeleteCheckAlert: (NSIndexPath *)indexPath {
    UIAlertView *alertView = [[UIAlertView alloc] init];
    alertView.delegate = self;
    self.indexToDelete = indexPath;
    alertView.message = @"Go home you're drunk!";
    [alertView addButtonWithTitle:@"HA jk..."];
    [alertView addButtonWithTitle:@"Derete"];
    [alertView show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    if (buttonIndex == 0 )
    {
        [self.tableView setEditing:NO animated:YES];
    }
    else
    {
        [self.todoListArray removeObjectAtIndex:self.indexToDelete.row];
        [self.checkedIndexes removeObjectAtIndex:self.indexToDelete.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:self.indexToDelete] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView reloadData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
