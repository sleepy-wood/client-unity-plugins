#ifndef InteropHelpers_h
#define InteropHelpers_h

typedef struct {
    int code;
    char* localizedDescription;
    long taskId;
} InteropError;

typedef struct {
    void* pointer;
    int length;
} InteropStructArray;

typedef struct {
    InteropStructArray keys;
    InteropStructArray values;
} InteropStructDictionary;

#endif
