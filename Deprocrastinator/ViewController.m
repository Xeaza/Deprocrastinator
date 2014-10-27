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
@property NSMutableArray *colorIndexPaths;

@property NSMutableArray *todoListArray;
@property NSIndexPath *indexToDelete;
@property NSArray *checkedItemsArray;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // TODO: Make TextField scroll up when user starts typing so you can see it.
    // TODO: Make return key on keyboard resignFirstResponder for keyboard and animate textField back back to it's place on the bottom
    self.indexToDelete = [[NSIndexPath alloc] init];
    self.todoListArray = [NSMutableArray arrayWithObjects:@"Sky Dive from Sears Tower", @"Sky Dive from Sears Tower", @"Sky Dive from Sears Tower", @"Sky Dive from Sears Tower", @"Sky Dive from Sears Tower", @"Sky Dive from Sears Tower", @"Sky Dive from Sears Tower", @"Sky Dive from Sears Tower", @"Sky Dive from Sears Tower", @"Sky Dive from Sears Tower", @"Sky Dive from Sears Tower", @"Sky Dive from Sears Tower", @"Sky Dive from Sears Tower", @"Sky Dive from Sears Tower", @"Eat Cake", @"Tickle a Dragon", @"Don't Panic", nil];

    self.colorIndexPaths = [[NSMutableArray alloc] init];
    self.checkedIndexes = [[NSMutableArray alloc] init];
    // Created array of 0s indicating that no cells have been selected (i.e. no checkmark added) as well as an array of text indicating the color of the textLabels
    for (int i = 0; i < self.todoListArray.count; i++)
    {
        [self.checkedIndexes addObject:[NSNumber numberWithBool:NO]];
        [self.colorIndexPaths addObject:@"Black"];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.todoListArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSString *cellIdentifier = @"toDoListCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    cell.textLabel.text = [self.todoListArray objectAtIndex:indexPath.row];
    [cell setAccessoryType:UITableViewCellAccessoryNone];

    BOOL shouldBeChecked = [[self.checkedIndexes objectAtIndex:indexPath.row] boolValue];

    if (shouldBeChecked)
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }

    if (self.colorIndexPaths)
    {

        if ([[self.colorIndexPaths objectAtIndex:indexPath.row] isEqualToString:@"Black"])
        {
            cell.textLabel.textColor = [UIColor blackColor];
        } else if ([[self.colorIndexPaths objectAtIndex:indexPath.row] isEqualToString:@"Green"])
        {
            cell.textLabel.textColor = [UIColor greenColor];
        } else if ([[self.colorIndexPaths objectAtIndex:indexPath.row] isEqualToString:@"Yellow"])
        {
            cell.textLabel.textColor = [UIColor yellowColor];
        } else if ([[self.colorIndexPaths objectAtIndex:indexPath.row] isEqualToString:@"Red"])
        {
            cell.textLabel.textColor = [UIColor redColor];
        }
    }

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL currentValue = [[self.checkedIndexes objectAtIndex:indexPath.row] boolValue];
    BOOL updatedValue = !currentValue;

    self.checkedIndexes[indexPath.row] = [NSNumber numberWithBool:updatedValue];

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [tableView reloadData];
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
 //
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self showDeleteCheckAlert: indexPath];
    }
}

- (IBAction)onAddButtonPressed:(id)sender
{
    NSString *usersText = self.addToDoItemTextField.text;
    [self.todoListArray addObject:usersText];
    [self.checkedIndexes addObject:[NSNumber numberWithBool:NO]];
    [self.tableView reloadData];

    self.addToDoItemTextField.text = nil;
    [self.addToDoItemTextField resignFirstResponder];
}

- (IBAction)onEditButtonPressed:(UIButton *)editButton
{
    if ([editButton.titleLabel.text isEqualToString:@"Edit"])
    {
        [editButton setTitle:@"Done" forState:UIControlStateNormal];
        // TODO Add Logic to delete a rows
        [self.tableView setEditing:YES animated:YES];
    }
    else
    {
        [editButton setTitle:@"Edit" forState:UIControlStateNormal];
        [self.tableView setEditing:NO animated:YES];
    }
}

- (IBAction)onSwipeGesture:(UISwipeGestureRecognizer *)swipeGesture
{
    CGPoint point = [swipeGesture locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];

    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if (cell.textLabel.textColor == [UIColor blackColor])
    {
        cell.textLabel.textColor = [UIColor greenColor];
        [self.colorIndexPaths replaceObjectAtIndex:indexPath.row withObject:@"Green"];
    }
    else if (cell.textLabel.textColor == [UIColor greenColor])
    {
        cell.textLabel.textColor = [UIColor yellowColor];
        [self.colorIndexPaths replaceObjectAtIndex:indexPath.row withObject:@"Yellow"];
    }
    else if (cell.textLabel.textColor == [UIColor yellowColor])
    {
        cell.textLabel.textColor = [UIColor redColor];
        [self.colorIndexPaths replaceObjectAtIndex:indexPath.row withObject:@"Red"];
    }
    else if (cell.textLabel.textColor == [UIColor redColor])
    {
        cell.textLabel.textColor = [UIColor blackColor];
        [self.colorIndexPaths replaceObjectAtIndex:indexPath.row withObject:@"Black"];
    }

}

- (void)showDeleteCheckAlert: (NSIndexPath *)indexPath
{
    UIAlertView *alertView = [[UIAlertView alloc] init];
    alertView.delegate = self;
    self.indexToDelete = indexPath;
    alertView.message = @"Go home you're drunk!";
    [alertView addButtonWithTitle:@"HA jk..."];
    [alertView addButtonWithTitle:@"Derete"];
    [alertView show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
