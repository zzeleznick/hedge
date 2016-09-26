from __future__ import print_function
from Foundation import *
from AppKit import *
import os
import datetime
import json
from collections import OrderedDict as OD

fields = ["RX", "DIN", "TIME"]
values = ["7433419",  "00441635", datetime.datetime.now().strftime("%H:%M %m-%d")]
DATA = OD(zip(fields, values))

def get_user_input():
    rx = input('Enter an Rx number: ').strip()
    DATA["RX"] = rx if rx else DATA.get("RX")
    if not rx:
        print("Error with input, using default:\n%s" % DATA["RX"])
    din = input('Enter a DIN number: ').strip()
    DATA["DIN"] = din if din else DATA.get("DIN")
    if not din:
        print("Error with input, using default:\n%s" % DATA["DIN"])
    return DATA

def main():
    props = get_user_input()
    inputText = "\n\n\n\t" + "\n\n\t".join(("%s: %s" % (key, val) for key, val in props.items() if val))
    image = NSImage.alloc().initWithSize_(NSMakeSize(1280, 1024))
    attrs = {}
    attrs[NSFontAttributeName] = NSFont.fontWithName_size_("Helvetica", 48)
    attrs[NSForegroundColorAttributeName] = NSColor.whiteColor()
    image.lockFocusFlipped_(True)
    text = NSString.alloc().initWithString_(inputText)
    text.drawAtPoint_withAttributes_(NSMakePoint(10, 10), attrs)
    image.unlockFocus()
    path = os.path.expanduser("~/GeneratedBackground.png")
    path2 = os.path.expanduser("~/GeneratedBackground2.png")

    if os.path.isfile(path):
        os.remove(path)
        path = path2

    if os.path.isfile(path2):
        os.remove(path2)

    NSBitmapImageRep.imageRepWithData_(image.TIFFRepresentation()).representationUsingType_properties_(
        NSPNGFileType, {NSImageCompressionFactor: NSNumber.numberWithFloat_(1.0)}).writeToFile_atomically_(path, False)
    os.system('osascript -e \'tell application "Finder" to set desktop picture to POSIX file "{}"\''.format(path))
    os.system('cp %s bk.png' % path)
    # os.system('open bk.png')

if __name__ == '__main__':
    main()

