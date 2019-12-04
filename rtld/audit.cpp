#include <link.h>
#include <stdio.h>

// must be defined
unsigned int la_version(unsigned int version) {
	printf("Auditing interface version: %u\n", version);
	return version;
}

// invoked by the dynamic linker to inform the library
// that it is about to search for a shared object
// name - file or path to be searched for
// cookie - identifies the shared object that init the search
char *la_objsearch(char *name, uintptr_t *cookie, unsigned int flag) {
	printf("Searching for shared object %s. Cookie = %p, flag = %s\n", name, cookie,
		(flag == LA_SER_ORIG) ? "LA_SER_ORIG" : // filename given to dlopen or from DT_NEEDED
		(flag == LA_SER_LIBPATH) ? "LA_SER_LIBPATH" : // created via dir in LD_LIBRARY_PATH
		(flag == LA_SER_RUNPATH) ? "LA_SER_RUNPATH" :  // create via dir in DT_RPATH or DT_RUNPATH
		(flag == LA_SER_CONFIG) ? "LA_SER_CONFIG" : // found via ldconfig cache
		(flag == LA_SER_DEFAULT) ? "LA_SER_DEFAULT" : // found via deafult directory
		(flag == LA_SER_SECURE) ? "LA_SER_SECURE" // specific to a secure object
		: "??? FLAG");
	return name;
}

void la_activity(uintptr_t *cookie, unsigned int flag) {
	printf("Link map activity:\n Cookie = %p, flag = %s\n\n", cookie,
		(flag == LA_ACT_CONSISTENT) ? "LA_ACT_CONSISTENT" : // activity completed
		(flag == LA_ACT_ADD) ? "LA_ACT_ADD" : // objects added to link map
		(flag == LA_ACT_DELETE) ? "LA_ACT_DELETE" : // objects removed from link map
		"??? FLAG");
}

unsigned int la_objopen(struct link_map *map, Lmid_t lmid, uintptr_t *cookie) {
	printf("loading shared object: %s, flag = %s\n\n", map->l_name, 
		(lmid == LM_ID_BASE) ? "LM_ID_BASE" : // part of initial namespace
		(lmid == LM_ID_NEWLM) ? "LM_ID_NEWLM" : // new namespace via dlopen
		"??? FLAG");
	return LA_FLG_BINDTO | LA_FLG_BINDFROM;
}

unsigned int la_objclose(uintptr_t *cookie) {
	printf("About to unload object. Cookie = %p\n", cookie);
	return 0; // ignored
}

void la_preinit(uintptr_t *cookie) {
	printf("Dynamic linker finished. Passing back to application\n");
}

uintptr_t la_symbind64(Elf64_Sym *sym, unsigned int ndx, uintptr_t *refcook,
	uintptr_t *defcook, int *flags, const char *symname) {
	printf("la_symbind64()\n");
	return sym->st_value;
}
