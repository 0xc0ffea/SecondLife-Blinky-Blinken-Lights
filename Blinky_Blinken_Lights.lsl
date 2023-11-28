///************************************************//
// Xmas Blinky Blinken LIghts
// Copyright (C) 2023 Coffee Pancake
// Released under the MIT Licence (http://opensource.org/licenses/MIT)
// Source : https://github.com/0xc0ffea/SecondLife-Blinky-Blinken-Lights
//************************************************//
// Version 1.0
// - OOoh look, blinky lights
//************************************************//

// Faces to be blinken
list    faces = [0,1,2,3,4,5,6];

// colours to be choosin (in hex, no #)
list colours = [
// mmm truetone classicolor .. 
    "FDFFFD", //white
    "FF1138", //red
    "1DEE00", //green
    "0047FF", //blue (more of a green, but thats what we want)
    "FFE600" //orange

];
//same as above .. just deluminated .. 
list colours_off = [
    "E8FEFD", //white
    "950000", //red
    "0DF903", //green
    "004BEF", //blue
    "F05611" //orange
];
integer colours_count;
// list of 7 light shades for current pattern
list colours_active;
// are the lights on or off
integer light_state = TRUE;
// are the lights running
integer light_running   = TRUE;

//how much glow
float   glow_amount = 0.35;
//how often to change
float   timer_frequency = 0.5;
// light mode !
integer light_mode = 2;

//------------------------------------------------//
vector Hex2Vector(string hex)
{
    float r = (float)("0x"+llGetSubString(hex, 0, 1))/255;
    float g = (float)("0x"+llGetSubString(hex, 2, 3))/255;
    float b = (float)("0x"+llGetSubString(hex, 4, 5))/255;

    return <r,g,b>;
}
//------------------------------------------------//
SetLights(integer mode) {

    list colour_use;
    colour_use = colours;
    if (light_state == FALSE) {
        colour_use = colours_off;
    } 

    //build active lights list
    integer n;integer c;integer cl;


    // random selection that flashes on and off
    if (mode == 1) {
        if (colours_active == []) {
            for (n=0;n<7;n++) {
                if (c+1 > colours_count) {c=0;}
                colours_active += [llList2String(colour_use,c)];
                c++;
            }
        }
    }
    // random colours without repeatseach time
    else if (mode == 2) {
        //if (!light_state) {return;}
        // 7 random colours without repeatseach time
        colours_active = [];
        for (n=0;n<7;n++) {
            do {
                c = (integer)llFrand(colours_count);
                //llOwnerSay((string)c);
            } while (c==cl);
            cl = c;
            colours_active += [llList2String(colour_use,c)];
        }
    }
    // chasing
    else if (mode == 3) {
        if (colours_active == []) {
            for (n=0;n<7;n++) {
                if (c > colours_count) {c=0;}
                colours_active += [llList2String(colour_use,c)];
                c++;
            }
        } else {
            c = (integer)llFrand(colours_count);
            colours_active += [llList2String(colour_use,c)];
            colours_active = llList2List(colours_active,1,-1);
        }
    }
    // alternating colour 0 and colour 1
    else if (mode == 4) {
        if (colours_active == []) {
            for (n=0;n<7;n++) {
                if (c > 1) {c=0;}
                colours_active += [llList2String(colour_use,c)];
                c++;
            }
        } else {
            colours_active += [llList2String(colours_active,1)];
            colours_active = llList2List(colours_active,1,-1);
        }
    }

    llSetLinkPrimitiveParamsFast(LINK_THIS,[
        //PRIM_COLOR,ALL_SIDES,<0,0,0>,1.0,
        PRIM_FULLBRIGHT,0,light_state,
        PRIM_FULLBRIGHT,1,light_state,
        PRIM_FULLBRIGHT,2,light_state,
        PRIM_FULLBRIGHT,3,light_state,
        PRIM_FULLBRIGHT,4,light_state,
        PRIM_FULLBRIGHT,5,light_state,
        PRIM_FULLBRIGHT,6,light_state,
        //PRIM_FULLBRIGHT,7,FALSE,
        PRIM_GLOW,0,glow_amount*light_state,
        PRIM_GLOW,1,glow_amount*light_state,
        PRIM_GLOW,2,glow_amount*light_state,
        PRIM_GLOW,3,glow_amount*light_state,
        PRIM_GLOW,4,glow_amount*light_state,
        PRIM_GLOW,5,glow_amount*light_state,
        PRIM_GLOW,6,glow_amount*light_state,
        //PRIM_GLOW,7,0.0,
        PRIM_COLOR,0,Hex2Vector(llList2String(colours_active,0)),1.0,
        PRIM_COLOR,1,Hex2Vector(llList2String(colours_active,1)),1.0,
        PRIM_COLOR,2,Hex2Vector(llList2String(colours_active,2)),1.0,
        PRIM_COLOR,3,Hex2Vector(llList2String(colours_active,3)),1.0,
        PRIM_COLOR,4,Hex2Vector(llList2String(colours_active,4)),1.0,
        PRIM_COLOR,5,Hex2Vector(llList2String(colours_active,5)),1.0,
        PRIM_COLOR,6,Hex2Vector(llList2String(colours_active,6)),1.0
    ]);

    if (mode == 1) {
        light_state = !light_state;
    }
}

default
{
    //************************************************//
    state_entry()
    {
        colours_count = llGetListLength(colours);
        llSetLinkPrimitiveParamsFast(LINK_THIS,[
                PRIM_COLOR,ALL_SIDES,Hex2Vector("567e04"),1.0,
                PRIM_FULLBRIGHT,ALL_SIDES,FALSE,
                PRIM_GLOW,ALL_SIDES,0.0
        ]);

        SetLights(light_mode);
        llSetTimerEvent(timer_frequency);
    }
    //************************************************//
    // switch em on and off when touched
    touch_end(integer num)
    {
        light_running = !light_running;
        light_state = light_running;
        SetLights(light_mode*light_running);
        llSetTimerEvent(timer_frequency*light_running);
        SetLights(light_mode*light_running);
    }
    //************************************************//
    timer() {
        SetLights(light_mode);
    }
    //************************************************//
}
