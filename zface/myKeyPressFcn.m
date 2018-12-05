function myKeyPressFcn(hObject, event)
    ck = get(hObject,'currentkey');
    global KEY_IS_PRESSED;
    KEY_IS_PRESSED  = ck;
end