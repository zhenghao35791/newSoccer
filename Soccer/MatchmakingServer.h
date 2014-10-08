//
//  MatchmakingServer.h
//  Snap
//
//  Created by Finguitar on 24/09/2014.
//  Copyright (c) 2014 Hollance. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MatchmakingServer;
@protocol MatchmakingServerDelegate <NSObject>

-(void) matchmakingServer:(MatchmakingServer *)server clientDidConnect:(NSString *)peerID;
-(void) matchmakingServer:(MatchmakingServer *)server clientDidDisconnect:(NSString *)peerID;
- (void)matchmakingServerSessionDidEnd:(MatchmakingServer *)server;
- (void)matchmakingServerNoNetwork:(MatchmakingServer *)server;

@end


@interface MatchmakingServer : NSObject<GKSessionDelegate>


@property (nonatomic, weak) id <MatchmakingServerDelegate> delegate;
@property (nonatomic, assign) int maxClients;
@property (nonatomic, strong, readonly) NSArray *connectedClients;
@property (nonatomic, strong, readonly) GKSession *session;



- (void)endSession;
- (void)startAcceptingConnectionsForSessionID:(NSString *)sessionID;
- (NSUInteger)connectedClientCount;
- (NSString *)peerIDForConnectedClientAtIndex:(NSUInteger)index;
- (NSString *)displayNameForPeerID:(NSString *)peerID;

@end

