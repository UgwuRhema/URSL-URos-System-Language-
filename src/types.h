#ifndef URSL_TYPES_H
#define URSL_TYPES_H

/*type kinds*/
typedef enum {
	TY_U64, TY_I64, TY_U32, TY_I32,
	TY_U16, TY_I16, TY_U8, TY_I8,
	TY_VOID, TY_NAMED
} TypeKind; /*primitive kinds are just tags*/

/*type reference*/
typedef struct {
	TypeKind kind;  /* primitive kind or TY_NAMED */
	char *name;     /* struct name when kind is TY_NAMED */
} TypeRef;

#endif
