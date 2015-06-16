//
//  SaveDataHelper.m
//  Pletoon
//
//  Created by Adriana Elizondo on 6/13/15.
//  Copyright (c) 2015 Adriana. All rights reserved.
//

#import "SaveDataHelper.h"

@implementation SaveDataHelper

#pragma mark - Save comic primary data
-(void)saveComic:(PLComic *)plComic withOrder:(NSInteger)order andEpisodes:(NSArray *)comicEpisodes{
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        Comic *comic = [Comic MR_createEntityInContext:localContext];
        comic.comicId = @(plComic.comicId);
        comic.title = plComic.comicTitle;
        comic.comicDescription = plComic.comicDescription;
        comic.isHighlighted = @(plComic.isHighlighted);
        comic.rating = @(plComic.rating);
        comic.principalCategory = plComic.principalCategory;
        comic.language = plComic.language;
        
        //Comic Images
        NSURL *squareImageUrl = [NSURL URLWithString:plComic.squareImageUrl];
        NSData *squareImageData = [NSData dataWithContentsOfURL:squareImageUrl];
        comic.squareImage = squareImageData;
        
        NSURL *highlightedImageUrl = [NSURL URLWithString:plComic.highlightedImageUrl];
        NSData *highlitedImageData = [NSData dataWithContentsOfURL:highlightedImageUrl];
        comic.highlightedImage = highlitedImageData;
        
        //Artist data
        NSDictionary *artistInfo = plComic.artist;
        Artist *artist = [Artist MR_createEntityInContext:localContext];
        artist.name = [artistInfo objectForKey:@"name"];
        artist.email = [artistInfo objectForKey:@"email"];
        
        NSURL *avatarUrl = [NSURL URLWithString:[artistInfo objectForKey:@"avatar"]];
        NSData *avatarData = [NSData dataWithContentsOfURL:avatarUrl];
        artist.avatar = avatarData;
        artist.comic = comic;
        
        //Categories data
        NSArray *categories = plComic.categories;
        [categories enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            Categories *category = [Categories MR_createEntityInContext:localContext];
            category.title = [obj objectForKey:@"title"];
            category.backgroundColor = [obj objectForKey:@"background_color"];
            category.comic = comic;
        }];
        
    } completion:^(BOOL success, NSError *error) {
        if (success) {
             [self saveEpisodes:comicEpisodes toComicWithId:@(plComic.comicId) withOrder:order];
        }else{
            NSLog(@"error %@", error);
            [self.delegate errorSaving:order withMessage:@"Download Error"];
        }
    }];
    
}

#pragma mark - Save episodes to comic
-(void)saveEpisodes:(NSArray *)episodes toComicWithId:(NSNumber *)comicId withOrder:(NSInteger)order{
    __block int episodesSaved = 1;
    [episodes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
            Episode *episode = [Episode MR_createEntityInContext:localContext];
            episode.episodeId = @([[obj objectForKey:@"id"] integerValue]);
            episode.order = @([[obj objectForKey:@"order"] integerValue]);
            episode.title = [obj objectForKey:@"title"];
            episode.likes = @([[obj objectForKey:@"n_likes"] integerValue]);
            episode.comments = @([[obj objectForKey:@"n_comments"] integerValue]);
            
            NSURL *coverImageUrl = [NSURL URLWithString:[obj objectForKey:@"cover_picture_image"]];
            NSData *coverImage = [NSData dataWithContentsOfURL:coverImageUrl];
            episode.coverPictureImage = coverImage;
            
            NSArray *images = [obj objectForKey:@"images"];
            [images enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                EpisodeImages *image = [EpisodeImages MR_createEntityInContext:localContext];
                image.order = @([[obj objectForKey:@"order"] integerValue]);
                
                NSURL *episodeImageUrl = [NSURL URLWithString:[obj objectForKey:@"image"]];
                NSData *episodeImage = [NSData dataWithContentsOfURL:episodeImageUrl];
                image.image = episodeImage;
                image.episode = episode;
                
            }];
            
            Comic* comic = [Comic MR_findFirstByAttribute:@"comicId" withValue:comicId inContext:localContext];
            episode.comic = comic;
            
            //Verify all comic data is complete
            if (episodesSaved == episodes.count) {
                comic.isCompletelyDownloaded = @(1);
            }
            
        } completion:^(BOOL contextDidSave, NSError *error) {
            //Check if an error happened while saving
          if(error){
                *stop = YES;
                [self.delegate errorSaving:order withMessage:@"Download Error"];
                
                //Delete corrupted download
                [self deleteIncompleteDownload:comicId];

            }else{
                if (episodesSaved == 1) {
                    [self.delegate startedSavingToDisk:order];
                }
                float totalEpisodes = (float)episodes.count;
                float progress = (episodesSaved / totalEpisodes);
                
                if (episodesSaved == episodes.count) {
                    [self.delegate saveCompletedSuccessfully:order];
                }
                //Update progress
                [self.delegate updateProgressWithValue:progress forDownload:order];
                episodesSaved ++;
            }
            
        }];
    }];
    
}

-(void)deleteIncompleteDownload:(NSNumber *)comicId{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"comicId = %@", comicId];
    [Comic MR_deleteAllMatchingPredicate:predicate];
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];

}

@end
