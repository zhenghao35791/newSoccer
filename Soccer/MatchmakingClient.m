//
//  MatchmakingClient.m
//  Snap
//
//  Created by Finguitar on 24/09/2014.
//  Copyright (c) 2014 Hollance. All rights reserved.
//

#import "MatchmakingClient.h"

typedef enum
{
    ClientStateIdle,
    ClientStateSearchingForServers,
    ClientStateConnecting,
    ClientStateConnected,
}
ClientState;

@implementation MatchmakingClient
{
    NSMutableArray *_availableServers;
    ClientState _clientState;
}


@synthesize session = _session;

- (id)init
{
    if((self = [super init]))
    {
        _clientState = ClientStateIdle;
    }
    return self;
}

- (void)startSearchingForServersWithSessionID:(NSString *)sessionID
{
    if(_clientState == ClientStateIdle)
    {
        _clientState = ClientStateSearchingForServers;
        _availableServers = [NSMutableArray arrayWithCapacity:10];
        
        _session = [[GKSession alloc] initWithSessionID:sessionID displayName:nil sessionMode:GKSessionModeClient];
        _session.delegate = self;
        _session.available = YES;

    }
}

- (NSArray *)availableServers
{
    return _availableServers;
}

#pragma mark - GKSessionDelegate

- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state
{
#ifdef DEBUG
    NSLog(@"MatchmakingClient: peer %@ changed state %d", peerID, state);
#endif
    switch (state) {
        case GKPeerStateAvailable:
            if(_clientState == ClientStateSearchingForServers)
            {
                if (![_availableServers containsObject:peerID])
                {
                    // add avaliable server id to server list
                    [_availableServers addObject:peerID];
                    // show the avaliable server id to screen
                    [self.delegate matchmakingClient:self serverBecameAvailable:peerID];
                }
            }
            
            break;
            
        case GKPeerStateUnavailable:
            if(_clientState == ClientStateSearchingForServers)
            {
                if([_availableServers containsObject:peerID])
                {
                    [_availableServers removeObject:peerID];
                    [self.delegate matchmakingClient:self serverBecameUnavailable:peerID];
                }
                
            }
            
            break;
        
        case GKPeerStateConnected:
            if(_clientState == ClientStateConnecting)
            {
                _clientState = ClientStateConnected;
            }
            
            break;
        
        case GKPeerStateConnecting:
            
            break;
        case GKPeerStateDisconnected:
            if(_clientState == ClientStateConnected)
            {
                [self disconnectFromServer];
            }
            
            break;
            
        default:
            break;
    }
    
}

-(void)disconnectFromServer
{
    NSAssert(_clientState != ClientStateIdle, @"Wrong state");
    _clientState = ClientStateIdle;
    [_session disconnectFromAllPeers];
    _session.available = NO;
    _session.delegate = nil;
    _session = nil;
    
    _availableServers = nil;
    [self.delegate matchmakingClient:self didDisconnectFromServer:_serverPeerID];
    
}

-(void)connectToServerWithPeerID:(NSString *)peerID
{
    NSAssert(_clientState == ClientStateSearchingForServers, @"Wrong state");
    
    _clientState = ClientStateConnecting;
    _serverPeerID = peerID;
    [_session connectToPeer:peerID withTimeout:_session.disconnectTimeout];
}

- (void)session:(GKSession *)session didReceiveConnectionRequestFromPeer:(NSString *)peerID
{
#ifdef DEBUG
    NSLog(@"MatchmakingClient: connection request from peer %@", peerID);
#endif
}

- (void)session:(GKSession *)session connectionWithPeerFailed:(NSString *)peerID withError:(NSError *)error
{
#ifdef DEBUG
    NSLog(@"MatchmakingClient: connection with peer %@ failed %@", peerID, error);
#endif
    [self disconnectFromServer];
}

- (void)session:(GKSession *)session didFailWithError:(NSError *)error
{
#ifdef DEBUG
    NSLog(@"MatchmakingClient: session failed %@", error);
#endif
}

- (NSUInteger)availableServerCount
{
    return [_availableServers count];
}

-(NSString *)peerIDForAvailableServerAtIndex:(NSUInteger)index
{
    return [_availableServers objectAtIndex:index];
}

-(NSString *)displayNameForPeerID:(NSString *)peerID
{
    return [_session displayNameForPeer:peerID];
}
@end

