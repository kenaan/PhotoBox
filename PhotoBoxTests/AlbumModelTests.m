//
//  AlbumModelTests.m
//  PhotoBox
//
//  Created by Nico Prananta on 9/30/13.
//  Copyright (c) 2013 Touches. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "XCTestCase+Additionals.h"

#import "Album.h"
#import "PhotoBoxModel.h"
#import "Photo.h"
#import "Tag.h"

@interface AlbumModelTests : XCTestCase

@end

@implementation AlbumModelTests

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
    if ([NSPersistentStoreCoordinator persistentStoreCoordinator]) {
        [NSPersistentStoreCoordinator clearPersistentStore];
    }
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)testSerializeAlbum
{
    NSError *error;

    NSDictionary *albumDict = [self objectFromJSONFile:@"album"];
    Album *testAlbum = [MTLJSONAdapter modelOfClass:[Album class] fromJSONDictionary:albumDict error:&error];
    
    XCTAssert(testAlbum!=nil, @"Test album should not be nil");
    XCTAssert([testAlbum.albumId isEqualToString:albumDict[@"id"]], @"Expected test album id = %@. Actual = %@",albumDict[@"id"], testAlbum.albumId);
    XCTAssert([testAlbum.count intValue]==[albumDict[@"count"] intValue], @"Expected album count = %d. Actual = %d",[albumDict[@"count"] intValue], [testAlbum.count intValue]);
    XCTAssert([testAlbum.name isEqualToString:[albumDict objectForKey:@"name"]], @"Expected album name = %@. Actual = %@", [albumDict objectForKey:@"name"], testAlbum.name);
    NSURL *coverURL = [NSURL URLWithString:[[albumDict objectForKey:@"cover"] objectForKey:@"path200x200xCR"]];
    NSString *coverId = [[albumDict objectForKey:@"cover"] objectForKey:@"id"];
    XCTAssert([testAlbum.coverURL isEqual:coverURL], @"Expected cover URL: %@. Actual = %@", coverURL, testAlbum.coverURL);
    XCTAssert([testAlbum.coverId isEqualToString:coverId], @"Expected coverId: %@. Actual = %@", coverId, testAlbum.coverId);

    NSManagedObject *albumManagedObject = [MTLManagedObjectAdapter managedObjectFromModel:testAlbum insertingIntoContext:[NSManagedObjectContext mainContext] error:&error];
    XCTAssert(albumManagedObject != nil, @"Album managed object should not be nil");
    XCTAssert([[albumManagedObject valueForKey:@"albumId"] isEqualToString:[albumDict objectForKey:@"id"]], @"Expected album id = %@. Actual = %@", albumDict[@"id"], [albumManagedObject valueForKey:@"albumId"]);
    XCTAssert([[albumManagedObject valueForKey:@"coverURL"] isEqualToString:testAlbum.coverURL.absoluteString], @"Expected cover url = %@. Actual = %@", testAlbum.coverURL.absoluteString, [albumManagedObject valueForKey:@"coverURL"]);
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.entity = [NSEntityDescription entityForName:@"PBXAlbum" inManagedObjectContext:[NSManagedObjectContext mainContext]];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"albumId" ascending:NO]];
    NSArray *results = [[NSManagedObjectContext mainContext] executeFetchRequest:fetchRequest error:&error];
    XCTAssert(results.count==1, @"There should be only 1 album in db at this point. Actual = %d", results.count);
}
@end
