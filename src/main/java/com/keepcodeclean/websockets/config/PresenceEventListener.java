package com.keepcodeclean.websockets.config;

import com.keepcodeclean.websockets.service.WebSocketSessionServiceImpl;
import org.springframework.context.event.EventListener;
import org.springframework.web.socket.messaging.SessionConnectEvent;
import org.springframework.web.socket.messaging.SessionDisconnectEvent;

import java.security.Principal;

public class PresenceEventListener {

    private final WebSocketSessionServiceImpl webSocketSessionService;
    
    public PresenceEventListener(WebSocketSessionServiceImpl webSocketSessionService) {
        this.webSocketSessionService = webSocketSessionService;
    }

    @EventListener
    private void handleSessionConnected(SessionConnectEvent event) {
        Principal principal = event.getUser();
        webSocketSessionService.setUserSession(principal.getName(), principal);
    }

    @EventListener
    private void handleSessionDisconnect(SessionDisconnectEvent event) {
        Principal principal = event.getUser();
        webSocketSessionService.removeSession(principal.getName());
    }
}