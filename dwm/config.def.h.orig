/* See LICENSE file for copyright and license details. */
#include <X11/XF86keysym.h>
/* appearance */
static unsigned int borderpx  = 2;        /* border pixel of windows */
static const Gap default_gap  = {.isgap = 1, .realgap = 10, .gappx = 10};
static unsigned int snap      = 32;       /* snap pixel */
static const unsigned int systraypinning = 0;   /* 0: sloppy systray follows selected monitor, >0: pin systray to monitor X */
static const unsigned int systrayonleft = 0;   	/* 0: systray in the right corner, >0: systray on left of status text */
static const unsigned int systrayspacing = 2;   /* systray spacing */
static const int systraypinningfailfirst = 1;   /* 1: if pinning fails, display systray on the first monitor, False: display systray on the last monitor*/
static const int showsystray        = 1;     /* 0 means no systray */
static int showbar            = 1;        /* 0 means no bar */
static int topbar             = 1;        /* 0 means bottom bar */ static const char *fonts[]          = { 
	"Fira Code Medium:style=Medium,Regular:size=12:antialias=true:autohint=true",
	"FiraCode Nerd Font Mono:style=Medium,Regular:size=18:antialias=true:autohint=true"
};
static const char dmenufont[]       = "FiraCode Nerd Font Mono:style=Medium,Regular:size=12";
static char highpriority[] 	    = "brave,discord,spotify";
static char normbgcolor[]           = "#222222";
static char normbordercolor[]       = "#444444"; 
static char normfgcolor[]           = "#bbbbbb";
static char selfgcolor[]            = "#eeeeee";
static char selbordercolor[]        = "#005577";
static char selbgcolor[]            = "#005577";
static char *colors[][3] = {
       /*               fg           bg           border   */
       [SchemeNorm] = { normfgcolor, normbgcolor, normbordercolor },
       [SchemeSel]  = { selfgcolor,  selbgcolor,  selbordercolor  },
};
static const unsigned int baralpha = 0x22;
static const unsigned int baralpha2 = 0x44;
static const unsigned int borderalpha = 0x30;
static const unsigned int alphas[][3]      = {
	/*               fg      bg         border     */
	[SchemeNorm] = { OPAQUE, baralpha2, borderalpha },
	[SchemeSel]  = { OPAQUE, baralpha,  borderalpha },
};



/* tagging */
static const char *tags[] = {
	"", /* Internet */
	"", /* Terminal */
	"", /* Code */
	"ﭮ", /* Discord */
	"", /* Spotify */
	"6", /* Other */
	"7"  /* Other */
};

static const Rule rules[] = {
	/* xprop(1):
	 *	WM_CLASS(STRING) = instance, class
	 *	WM_NAME(STRING) = title
	 */
	/* class      instance    title       tags mask     isfloating   monitor */
	{ "Gimp",     NULL,       NULL,       0,            1,           -1 },
	{ "Firefox",  NULL,       NULL,       1 << 8,       0,           -1 },
};

/* layout(s) */
static float mfact     = 0.55; /* factor of master area size [0.05..0.95] */
static int nmaster     = 1;    /* number of clients in master area */
static int resizehints = 1;    /* 1 means respect size hints in tiled resizals */
static const int lockfullscreen = 1; /* 1 will force focus on the fullscreen window */

static const Layout layouts[] = {
	/* symbol     arrange function */
	{ "[]=",      tile },    /* first entry is default */
	{ "><>",      NULL },    /* no layout function means floating behavior */
	{ "[M]",      monocle },
};

/* key definitions */
#define MODKEY Mod4Mask
#define TAGKEYS(KEY,TAG) \
	{ MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
	{ MODKEY|ShiftMask,             KEY,      tag,            {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} },

/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd) { .v = (const char*[]){ "/usr/bin/alacritty", "-c", cmd, NULL } } /* commands */ static char dmenumon[2] = "0"; /* component of dmenucmd, manipulated in spawn() */
static char dmenumon[2] = "0";
static const char *dmenucmd[] = { "dmenu_run", "-m", dmenumon, "-fn", dmenufont, "-nb", normbgcolor, "-nf", normfgcolor, "-sb", selbgcolor, "-sf", selfgcolor, "-hp", highpriority, NULL };
static const char *termcmd[]  = { "alacritty", NULL };
static const char *takess[]  = { "flameshot", "gui", NULL };
static const char *cpicker[]  = { "cpicker", NULL };
static const char *powermen[]  = { "menu_powermenu", NULL };
static const char *bluemen[]  = { "rofi-bluetooth", NULL };
static const char *quickapps[]  = { "applet_apps", NULL };
static const char *brightup[]  = { "brightnessctl", "set", "5%+", NULL };
static const char *brightdown[]  = { "brightnessctl", "set", "5%-", NULL };
static const char *soundup[]  = { "amixer", "set", "Master", "5%+", NULL };
static const char *sounddown[]  = { "amixer", "set", "Master", "5%-", NULL };
static const char *soundtgl[]  = { "amixer", "set", "Master", "toggle", NULL };
static const char *musicpause[]  = { "playerctl", "play-pause", NULL };
static const char *musicnext[]  = { "playerctl", "next", NULL };
static const char *musicprev[]  = { "playerctl", "previous", NULL };


/*
 * Xresources preferences to load at startup
 */
ResourcePref resources[] = {
		{ "normbgcolor",        STRING,  &normbgcolor },
		{ "normbordercolor",    STRING,  &normbordercolor },
		{ "normfgcolor",        STRING,  &normfgcolor },
		{ "selbgcolor",         STRING,  &selbgcolor },
		{ "selbordercolor",     STRING,  &selbordercolor },
		{ "selfgcolor",         STRING,  &selfgcolor },
		{ "snap",          	INTEGER, &snap },
		{ "showbar",          	INTEGER, &showbar },
		{ "topbar",          	INTEGER, &topbar },
		{ "nmaster",          	INTEGER, &nmaster },
		{ "resizehints",       	INTEGER, &resizehints },
		{ "mfact",      	FLOAT,   &mfact },
		{ "highpriority",      	STRING,  &highpriority },
};

static Key keys[] = {
	/* modifier                     key		   function        argument */
	{ MODKEY,                       XK_p,		   spawn,          {.v = dmenucmd } },
	{ MODKEY|ShiftMask,             XK_Return,	   spawn,          {.v = termcmd } },
	{ MODKEY,                       XK_b,		   togglebar,      {0} },
	{ MODKEY,                       XK_v,		   togglebarpos,   {0} },
	{ MODKEY,                       XK_j,		   focusstack,     {.i = +1 } },
	{ MODKEY,                       XK_k,		   focusstack,     {.i = -1 } },
	{ MODKEY,                       XK_i,		   incnmaster,     {.i = +1 } },
	{ MODKEY,                       XK_d,		   incnmaster,     {.i = -1 } },
	{ MODKEY,                       XK_h,		   setmfact,       {.f = -0.05} },
	{ MODKEY,                       XK_l,		   setmfact,       {.f = +0.05} },
	{ MODKEY,                       XK_Return,	   zoom,           {0} },
	{ MODKEY,                       XK_Tab,		   view,           {0} },
	{ MODKEY|ShiftMask,             XK_c,		   killclient,     {0} },
	{ MODKEY,                       XK_t,		   setlayout,      {.v = &layouts[0]} },
	{ MODKEY,                       XK_f,		   setlayout,      {.v = &layouts[1]} },
	{ MODKEY,                       XK_m,		   setlayout,      {.v = &layouts[2]} },
	{ MODKEY,                       XK_space,	   setlayout,      {0} },
	{ MODKEY|ShiftMask,             XK_space,	   togglefloating, {0} },
	{ MODKEY,             		XK_n,      	   togglefullscr,  {0} },
	{ MODKEY,                       XK_0,		   view,           {.ui = ~0 } },
	{ MODKEY|ShiftMask,             XK_0,		   tag,            {.ui = ~0 } },
	{ MODKEY,                       XK_comma,	   focusmon,       {.i = -1 } },
	{ MODKEY,                       XK_period,	   focusmon,       {.i = +1 } },
	{ MODKEY|ShiftMask,             XK_comma,	   tagmon,         {.i = -1 } },
	{ MODKEY|ShiftMask,             XK_period,	   tagmon,         {.i = +1 } },
	/* Custom keybinds */
	{ MODKEY,                       XK_minus,	   setgaps,        {.i = -5 } },
	{ MODKEY,                       XK_equal,	   setgaps,        {.i = +5 } },
	{ MODKEY,             		XK_backslash,  	   setgaps,        {.i = GAP_RESET } },
	{ MODKEY|ShiftMask,             XK_backslash,  	   setgaps,        {.i = GAP_TOGGLE } },
	{ MODKEY,                       XK_bracketleft,	   setborderpx,    {.i = -1 } },
	{ MODKEY,                       XK_bracketright,   setborderpx,    {.i = +1 } },
	{ MODKEY|ShiftMask,             XK_s,   	   spawn,          {.v = takess } },
	{ MODKEY|ShiftMask,             XK_g,   	   spawn,          {.v = cpicker } },
	{ MODKEY|ShiftMask,             XK_p,   	   spawn,          {.v = powermen } },
	{ MODKEY|ShiftMask,             XK_b,   	   spawn,          {.v = bluemen } },
	{ MODKEY|ShiftMask,             XK_a,   	   spawn,          {.v = quickapps } },
	/* Special keys keybinds */
	{ 0,             XF86XK_MonBrightnessUp,  	spawn,          {.v = brightup } },
	{ 0,             XF86XK_MonBrightnessDown,    	spawn,          {.v = brightdown } },
	{ 0,             XF86XK_AudioLowerVolume,     	spawn,          {.v = sounddown } },
	{ 0,             XF86XK_AudioMute,     	   	spawn,          {.v = soundtgl } },
	{ 0,             XF86XK_AudioRaiseVolume,     	spawn,          {.v = soundup } },
	{ 0,             XF86XK_AudioPlay,            	spawn,          {.v = musicpause } },
	{ 0,             XF86XK_AudioStop,     	   	spawn,          {.v = musicpause } },
	{ 0,             XF86XK_AudioPrev,     	   	spawn,          {.v = musicprev } },
	{ 0,             XF86XK_AudioNext,     	   	spawn,          {.v = musicnext } },

	/* Tag keys and else */
	TAGKEYS(                        XK_1,				   0)
	TAGKEYS(                        XK_2,				   1)
	TAGKEYS(                        XK_3,				   2)
	TAGKEYS(                        XK_4,				   3)
	TAGKEYS(                        XK_5,				   4)
	TAGKEYS(                        XK_6,				   5)
	TAGKEYS(                        XK_7,				   6)
	TAGKEYS(                        XK_8,				   7)
	TAGKEYS(                        XK_9,				   8)
	{ MODKEY|ShiftMask,             XK_q,		   quit,           {0} },
};

/* button definitions */
/* click can be ClkTagBar, ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static Button buttons[] = {
	/* click                event mask      button          function        argument */
	{ ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
	{ ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },
	{ ClkWinTitle,          0,              Button2,        zoom,           {0} },
	{ ClkStatusText,        0,              Button2,        spawn,          {.v = termcmd } },
	{ ClkClientWin,         MODKEY,         Button1,        movemouse,      {0} },
	{ ClkClientWin,         MODKEY,         Button2,        togglefloating, {0} },
	{ ClkClientWin,         MODKEY,         Button3,        resizemouse,    {0} },
	{ ClkTagBar,            0,              Button1,        view,           {0} },
	{ ClkTagBar,            0,              Button3,        toggleview,     {0} },
	{ ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
	{ ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },
};

