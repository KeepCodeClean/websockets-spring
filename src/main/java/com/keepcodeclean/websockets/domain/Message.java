package com.keepcodeclean.websockets.domain;

import lombok.Data;

@Data
public class Message {
    private final String from;
    private final String content;
}
