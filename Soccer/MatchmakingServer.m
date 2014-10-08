//
//  MatchmakingServer.m
//  Snap
//
//  Created by Finguitar on 24/09/2014.
//  Copyright (c) 2014 Hollance. All rights reserved.
//

#import "MatchmakingServer.h"

typedef enum
{
    ServerStateIdle,
    ServerStateAcceptingConnections,
    ServerStateIgnoringNewConnections,
}ServerState;

@interface MatchmakingServer ()

@end



@implementation MatchmakingServer

{
    NSMutableArray *_connectedClients;
    ServerState _serverstate;
    
}
@synthesize delegate = _delegate;


-(id)init
{
    NSLog(@"Server init");
    if(self = [super init])
    {
        _serverstate = ServerStateIdle;
    }
    return self;
}

- (void)startAcceptingConnectionsForSessionID:(NSString *)sessionID
{
    
    if(_serverstate == ServerStateIdle)
    {
        NSLog(@"server session started");
        _serverstate = ServerStateAcceptingConnections;
        _connectedClients = [NSMutableArray arrayWithCapacity:self.maxClients];
    
        _session = [[GKSession alloc] initWithSessionID:sessionID displayName:nil sessionMode:GKSessionModeServer];
        _session.delegate = self;
        _session.available = YES;
    }
}

- (NSArray *)connectedClients
{
    return _connectedClients;
}

#pragma mark - GKSessionDelegate

- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state
{
    NSLog(@"MatchmakingServer: peer %@ changed state %d", peerID, state);

#ifdef DEBUG
    NSLog(@"MatchmakingServer: peer %@ changed state %d", peerID, state);
#endif
    switch (state) {
        case GKPeerStateAvailable:
            break;
        case GKPeerStateUnavailable:
            break;
            
        case GKPeerStateConnected:
            if(_serverstate == ServerStateAcceptingConnections)
            {
                if(![_connectedClients containsObject:peerID])
                {
                    [_connectedClients addObject:peerID];
                    NSLog(@"server add %@", peerID);
                    [self.delegate matchmakingServer:self clientDidConnect:peerID ];
                }
            }
            break;
            
        case GKPeerStateDisconnected:
            if(_serverstate != ServerStateIdle)
            {
                if([_connectedClients containsObject:peerID])
                {
                    [_connectedClients removeObject:peerID];
                    [self.delegate matchmakingServer:self clientDidDisconnect:peerID];
                }
                
            }
            break;
        case GKPeerStateConnecting:

            break;


            
        default:
            break;
    }
    
}

- (void)session:(GKSession *)session didReceiveConnectionRequestFromPeer:(NSString *)peerID
{
#ifdef DEBUG
    NSLog(@"MatchmakingServer: connection request from peer %@", peerID);
#endif
    
    if (_serverstate == ServerStateAcceptingConnections && [self connectedClientCount] < self.maxClients)
    {
        NSError *error;
        if ([session acceptConnectionFromPeer:peerID error:&error])
            NSLog(@"MatchmakingServer: Connection accepted from peer %@", peerID);
        else
            NSLog(@"MatchmakingServer: Error accepting connection from peer %@, %@", peerID, error);
    }
    else  // not accepting connections or too many clients
    {
        [session denyConnectionFromPeer:peerID];
    }
}

- (void)endSession
{
    NSAssert(_serverstate != ServerStateIdle, @"Wrong state");
    
    _serverstate = ServerStateIdle;
    
    [_session disconnectFromAllPeers];
    _session.available = NO;
    _session.delegate = nil;
    _session = nil;
    
    _connectedClients = nil;
    
    [self.delegate matchmakingServerSessionDidEnd:self];
}

- (void)session:(GKSession *)session connectionWithPeerFailed:(NSString *)peerID withError:(NSError *)error
{
#ifdef DEBUG
    NSLog(@"MatchmakingServer: connection with peer %@ failed %@", peerID, error);
#endif
}

- (void)session:(GKSession *)session didFailWithError:(NSError *)error
{
#ifdef DEBUG
    NSLog(@"MatchmakingServer: session failed %@", error);
#endif
    
    if([[error domain] isEqualToString:GKSessionErrorDomain])
    {
        if([error code] == GKSessionCannotEnableError)
        {
            [self.delegate matchmakingServerNoNetwork:self];
            [self endSession];
        }
    }
    
}

- (NSUInteger)connectedClientCount
{
    return [_connectedClients count];
}
- (NSString *)peerIDForConnectedClientAtIndex:(NSUInteger)index
{
    return [_connectedClients objectAtIndex:index];
}

- (NSString *)displayNameForPeerID:(NSString *)peerID
{
    return [_session displayNameForPeer:peerID];
}



@end
