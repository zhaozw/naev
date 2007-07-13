

#ifndef PHYSICS_H
#  define PHYSICS_H


#define VX(v)		((v).x)
#define VY(v)		((v).y)
#define VMOD(v)	((v).mod)
#define VANGLE(v)	((v).angle)

#define MOD(x,y)	(sqrt((x)*(x)+(y)*(y)))
#define ANGLE(x,y) (((x)==0.) ? 0. : (((x)<0.) ? atan((y)/(x))+M_PI : atan((y)/(x))))

#define DIST(v,u)	MOD((v).x-(u).x,(v).y-(u).y)


/*
 * misc
 */
double angle_diff( const double ref, double a );


/*
 * base of all 2d Vector work
 */
typedef struct {
	double x, y; /* cartesian values */
	double mod, angle; /* polar values */
} Vector2d;

/*
 * vector manipulation
 */
void vect_cset( Vector2d* v, const double x, const double y );
void vect_csetmin( Vector2d* v, const double x, const double y ); /* does not set mod nor angle */
void vect_pset( Vector2d* v, const double mod, const double angle );
void vectcpy( Vector2d* dest, const Vector2d* src );
void vectnull( Vector2d* v );
double vect_angle( const Vector2d* ref, const Vector2d* v );
void vect_cadd( Vector2d* v, const double x, const double y );


/*
 * used to describe any Solid in 2d space
 */
struct Solid {
	double mass, dir, dir_vel; /* properties */
	Vector2d vel, pos, force; /* position/velocity vectors */
	void (*update)( struct Solid*, const double ); /* update method */
};
typedef struct Solid Solid;


/*
 * solid manipulation
 */
void solid_init( Solid* dest, const double mass, const double dir,
		const Vector2d* pos, const Vector2d* vel );
Solid* solid_create( const double mass, const double dir,
		const Vector2d* pos, const Vector2d* vel );
void solid_free( Solid* src );


#endif /* PHYSICS_H */


