//
//  ViewController.m
//  Deprocrastinator
//
//  Created by Taylor Wright-Sanson on 10/6/14.
//  Copyright (c) 2014 Taylor Wright-Sanson. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *addToDoItemTextField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray *checkedIndexes;

@property NSMutableArray *todoListArray;

@end        // Update checkmarked buttson list

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.todoListArray = [NSMutableArray arrayWithObjects:@"Sky Dive from Sears Tower", @"Eat Cake", @"Tickle a Dragon", @"Don't Panic", nil];

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

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"toDoListCell" forIndexPath:indexPath];

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

    if ([self.tableView isEditing]) {
        [self.todoListArray removeObjectAtIndex:indexPath.row];
        [self.checkedIndexes removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView reloadData];

        [self.tableView setEditing:NO animated:YES];
        
    }
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.todoListArray removeObjectAtIndex:indexPath.row];
        [self.checkedIndexes removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView reloadData];

        [self.tableView setEditing:NO animated:YES];

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
- (IBAction)onEditButtonPressed:(id)sender {
    UIButton *tempButton = sender;
    if ([tempButton.titleLabel.text isEqualToString:@"Edit"]) {
        [tempButton setTitle:@"Done" forState:UIControlStateNormal];
        // Add Logic to delete a rows

        [self.tableView setEditing:YES animated:YES];

    } else {
        [tempButton setTitle:@"Edit" forState:UIControlStateNormal];
        [self.tableView setEditing:NO animated:NO];

    }
}

- (IBAction)onSwipeGesture:(UISwipeGestureRecognizer *)swipeGesture {
    CGPoint point = [swipeGesture locationInView:self.tableView];
    //NSLog(@"%f", point.x);

    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
    NSLog(@"%ld", (long)indexPath.row);

    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if (cell.textLabel.textColor == [UIColor blackColor]) {
        cell.textLabel.textColor = [UIColor greenColor];
    } else if (cell.textLabel.textColor == [UIColor greenColor]){
        cell.textLabel.textColor = [UIColor yellowColor];
    } else if (cell.textLabel.textColor == [UIColor yellowColor]) {
        cell.textLabel.textColor = [UIColor redColor];
    } else if (cell.textLabel.textColor == [UIColor redColor]) {
        cell.textLabel.textColor = [UIColor blackColor];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
