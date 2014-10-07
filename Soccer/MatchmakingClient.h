//
//  MatchmakingClient.h
//  Snap
//
//  Created by Finguitar on 24/09/2014.
//  Copyright (c) 2014 Hollance. All rights reserved.
//

#import <Foundation/Foundation.h>


@class MatchmakingClient;

@protocol MatchmakingClientDelegate <NSObject>

- (void)matchmakingClient:(MatchmakingClient *)client serverBecameAvailable:(NSString *)peerID;
- (void)matchmakingClient:(MatchmakingClient *)client serverBecameUnavailable:(NSString *)peerID;
- (void)matchmakingClient:(MatchmakingClient *)client didDisconnectFromServer:(NSString *)peerID;

@end

@interface MatchmakingClient : NSObject<GKSessionDelegate>
@property (nonatomic, strong, readonly) NSArray *availableServers;
@property (nonatomic, strong, readonly) GKSession *session;
@property (nonatomic, strong, readonly) NSString *serverPeerID;
@property (nonatomic, weak) id <MatchmakingClientDelegate> delegate;

- (void)startSearchingForServersWithSessionID:(NSString *)sessionID;
- (NSUInteger)availableServerCount;
- (NSString *)peerIDForAvailableServerAtIndex:(NSUInteger)index;
- (NSString *)displayNameForPeerID:(NSString *)peerID;
- (void)connectToServerWithPeerID:(NSString *)peerID;
- (void)disconnectFromServer;




@end
