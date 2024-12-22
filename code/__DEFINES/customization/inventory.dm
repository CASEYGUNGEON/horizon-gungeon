//Flags for bodytypes for species and clothing. If a clothing doesnt have a flag for a species, they cant wear the clothing
#define BODYTYPE_HUMANOID (1<<0)
#define BODYTYPE_DIGITIGRADE (1<<1) //Somewhat special bodytype, matters for digi legs for suits/uniforms aswell as snouts for head
#define BODYTYPE_TAUR_SNAKE (1<<2) //taur-friendly suits
#define BODYTYPE_TAUR_PAW (1<<3)
#define BODYTYPE_TAUR_HOOF (1<<4)
#define BODYTYPE_TAUR_COMMON (BODYTYPE_TAUR_SNAKE|BODYTYPE_TAUR_PAW)
#define BODYTYPE_TAUR_ALL (BODYTYPE_TAUR_SNAKE|BODYTYPE_TAUR_PAW|BODYTYPE_TAUR_HOOF)
#define BODYTYPE_VOX (1<<5)
#define BODYTYPE_TESHARI (1<<6)
#define BODYTYPE_DIONA (1<<7)
#define BODYTYPE_SKRELL (1<<8)
//All bodytypes
#define ALL_BODYTYPES (\
	BODYTYPE_HUMANOID|\
	BODYTYPE_DIGITIGRADE|\
	BODYTYPE_TAUR_SNAKE|\
	BODYTYPE_TAUR_PAW|\
	BODYTYPE_TAUR_HOOF|\
	BODYTYPE_VOX|\
	BODYTYPE_TESHARI|\
	BODYTYPE_DIONA|\
	BODYTYPE_SKRELL\
	)
//Bodytypes *mostly* resembling a humanoid, this is set on things by default
#define GENERIC_BODYTYPES (\
	BODYTYPE_HUMANOID|\
	BODYTYPE_DIGITIGRADE|\
	BODYTYPE_TAUR_SNAKE|\
	BODYTYPE_TAUR_PAW|\
	BODYTYPE_TAUR_HOOF|\
	BODYTYPE_VOX|\
	BODYTYPE_DIONA|\
	BODYTYPE_SKRELL\
	)

#define BODYTYPE_TRANSLATION_LIST list(\
		"[BODYTYPE_HUMANOID]" = "human",\
		"[BODYTYPE_DIGITIGRADE]" = "digi",\
		"[BODYTYPE_TAUR_SNAKE]" = "taursnake",\
		"[BODYTYPE_TAUR_PAW]" = "taurpaw",\
		"[BODYTYPE_TAUR_HOOF]" = "taurhoof",\
		"[BODYTYPE_VOX]" = "vox",\
		"[BODYTYPE_TESHARI]" = "teshari",\
		"[BODYTYPE_DIONA]" = "diona",\
		"[BODYTYPE_SKRELL]" = "skrell"\
		)
