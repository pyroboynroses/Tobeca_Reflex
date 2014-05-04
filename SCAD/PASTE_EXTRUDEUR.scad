r_608zz=11.25;
r_ext=35;
h_plaque=5;
r_m8=4.5;
r_m3=2;
r_tete_m3=3;
r_central=16;
ep=2;
h_central=120; //en fonction des longueurs de seringues

//paramètres des seringues
r_seringue=12.5; //11 pour seringue de 20mL et 12.5 pour seringue de 30mL
r_piston=11.5;		//11.5 pour seringue de 20mL et 13 pour seringue de 30mL

// You can get this file from http://www.thingiverse.com/thing:3575
use <parametric_involute_gear_v5.0.scad>

// Couple handy arithmetic shortcuts
function sqr(n) = pow(n, 2);
function cube(n) = pow(n, 3);

// This was derived as follows:
// In Greg Frost's original script, the outer radius of a spur
// gear can be computed as...
function gear_outer_radius(number_of_teeth, circular_pitch) =
	(sqr(number_of_teeth) * sqr(circular_pitch) + 64800)
		/ (360 * number_of_teeth * circular_pitch);

// We can fit gears to the spacing by working it backwards.
//  spacing = gear_outer_radius(teeth1, cp)
//          + gear_outer_radius(teeth2, cp);
//
// I plugged this into an algebra system, assuming that spacing,
// teeth1, and teeth2 are given.  By solving for circular pitch,
// we get this terrifying equation:
function fit_spur_gears(n1, n2, spacing) =
	(180 * spacing * n1 * n2  +  180
		* sqrt(-(2*n1*cube(n2)-(sqr(spacing)-4)*sqr(n1)*sqr(n2)+2*cube(n1)*n2)))
	/ (n1*sqr(n2) + sqr(n1)*n2);

//plaque qui maintien en place le grand pignon
module plaque_haute(){
	difference(){
		cylinder(r=r_ext+2, h=h_plaque, $fn=200);
		
		//trou de passage vis
		translate([0,0,-5]){cylinder(r=r_m8, h=h_plaque+10, $fn=50);}

		//extrusion pour roulement 608ZZ
		translate([0,0,2]){cylinder(r=r_608zz, h=h_plaque+10, $fn=100);}

		//trous de fixation
		translate([-r_ext+2,0,-5]){cylinder(r=r_m3, h=h_plaque+10, $fn=50);}
		translate([r_ext-2,0,-5]){cylinder(r=r_m3, h=h_plaque+10, $fn=50);}
		translate([0,-r_ext+2,-5]){cylinder(r=r_m3, h=h_plaque+10, $fn=50);}
		translate([0,r_ext-2,-5]){cylinder(r=r_m3, h=h_plaque+10, $fn=50);}

		//extrusion pour passage poulie moteur
		rotate([0,0,45])translate([r_ext,0,-5]){cylinder(r=12, h=h_plaque+10, $fn=100);}

		//allègement de la pièce
		rotate([0,0,45])translate([-r_ext-20,0,-5]){cylinder(r=32, h=h_plaque+10, $fn=200);}
		rotate([0,0,45])translate([r_ext+20,0,-5]){cylinder(r=32, h=h_plaque+10, $fn=200);}
		rotate([0,0,45])translate([0,r_ext+20,-5]){cylinder(r=32, h=h_plaque+10, $fn=200);}
		rotate([0,0,45])translate([0,-r_ext-20,-5]){cylinder(r=32, h=h_plaque+10, $fn=200);}
		
		
	}
}

module trous_nema17(){
hull(){
translate([-14.5,-15.5,-5]){cylinder(r=r_m3, h=20, $fn=50);}
translate([-16.5,-15.5,-5]){cylinder(r=r_m3, h=20, $fn=50);}
}

hull(){
translate([-14.5,15.5,-5]){cylinder(r=r_m3, h=20, $fn=50);}
translate([-16.5,15.5,-5]){cylinder(r=r_m3, h=20, $fn=50);}
}

hull(){
translate([14.5,-15.5,-5]){cylinder(r=r_m3, h=20, $fn=50);}
translate([16.5,-15.5,-5]){cylinder(r=r_m3, h=20, $fn=50);}
}

hull(){
translate([14.5,15.5,-5]){cylinder(r=r_m3, h=20, $fn=50);}
translate([16.5,15.5,-5]){cylinder(r=r_m3, h=20, $fn=50);}
}

}

//plaque qui supporte le moteur d'entraînement
module plaque_base(){
	difference(){
		hull(){
			cylinder(r=r_ext+2, h=h_plaque, $fn=200);
			//plaque pour support moteur
			rotate([0,0,45])translate([r_ext,0,0]){cylinder(r=27, h=h_plaque, $fn=100);}
		}
		//extrusion pour passage poulie moteur
		rotate([0,0,45])translate([r_ext,0,-5]){cylinder(r=12, h=h_plaque+10, $fn=100);}

		//trou de passage vis
		translate([0,0,-5]){cylinder(r=r_m8, h=h_plaque+10, $fn=50);}

		//extrusion pour roulement 608ZZ
		translate([0,0,2]){cylinder(r=r_608zz, h=h_plaque+10, $fn=100);}

		//trous de fixation sur plaque du haut
		translate([-r_ext+2,0,-5]){cylinder(r=r_m3, h=h_plaque+10, $fn=50);}
		translate([r_ext-2,0,-5]){cylinder(r=r_m3, h=h_plaque+10, $fn=50);}
		translate([0,-r_ext+2,-5]){cylinder(r=r_m3, h=h_plaque+10, $fn=50);}
		translate([0,r_ext-2,-5]){cylinder(r=r_m3, h=h_plaque+10, $fn=50);}


		//trous de fixation du moteur
		rotate([0,0,45])translate([r_ext,0,0]){rotate([0,0,0])trous_nema17();}
		

		//trous pour fixation à l'adaptateur central, fraisage
		rotate([0,0,45])translate([-(r_central+ep+10)+2.5,0,3]){cylinder(r1=r_m3, r2=r_tete_m3,h=2, $fn=50);}
		//rotate([0,0,45])translate([(r_central+ep+10)-2.5,0,3]){cylinder(r1=r_m3, r2=r_tete_m3,h=2, $fn=50);}
		rotate([0,0,45])translate([0,-(r_central+ep+10)+2.5,3]){cylinder(r1=r_m3, r2=r_tete_m3,h=2, $fn=50);}
		rotate([0,0,45])translate([0,(r_central+ep+10)-2.5,3]){cylinder(r1=r_m3, r2=r_tete_m3,h=2, $fn=50);}
		
		//trous pour fixation à l'adaptateur central, trous traversants
		rotate([0,0,45])translate([-(r_central+ep+10)+2.5,0,-5]){cylinder(r=r_m3, h=h_plaque+10, $fn=50);}
		//rotate([0,0,45])translate([(r_central+ep+10)-2.5,0,-5]){cylinder(r=r_m3, h=h_plaque+10, $fn=50);}
		rotate([0,0,45])translate([0,-(r_central+ep+10)+2.5,-5]){cylinder(r=r_m3, h=h_plaque+10, $fn=50);}
		rotate([0,0,45])translate([0,(r_central+ep+10)-2.5,-5]){cylinder(r=r_m3, h=h_plaque+10, $fn=50);}

		//allègement de la pièce
		rotate([0,0,45])translate([-r_ext-20,0,-5]){cylinder(r=27, h=h_plaque+10, $fn=200);}
		//rotate([0,0,45])translate([r_ext+20,0,-5]){cylinder(r=32, h=h_plaque+10, $fn=200);}
		rotate([0,0,45])translate([0,r_ext+20,-5]){cylinder(r=27, h=h_plaque+10, $fn=200);}
		rotate([0,0,45])translate([0,-r_ext-20,-5]){cylinder(r=27, h=h_plaque+10, $fn=200);}
	}
}

//tube central où sera la seringue
module tube_central(){
	difference(){
		union(){
		
		hull(){
		//disque de fixation
		cylinder(r=r_central+ep+10, h=3, $fn=100);

		//débordements sur les côtés pour fixation
		translate([-30,0,0]){cylinder(r=5, h=3, $fn=100);}
		translate([30,0,0]){cylinder(r=5, h=3, $fn=100);}
		}
		
		//renforcement bas
		translate([0,0,3]){cylinder(r=r_central+ep+4, h=20, $fn=100);}

		//renforcement verticaux
		translate([-r_central,0,0]){cylinder(r=5, h=h_central+8-16, $fn=100);}
		rotate([0,0,-15])translate([r_central,0,0]){cylinder(r=5, h=h_central+8-16, $fn=100);}

		//jonction renforcement / tube
		translate([0,0,23]){cylinder(r1=r_central+ep+4, r2=r_central+ep, h=5, $fn=100);}

		//tube central
		translate([0,0,8]){cylinder(r=r_central+ep, h=h_central, $fn=200);}
		}
		//extrusion centrale générale
		translate([0,0,5]){cylinder(r=r_central, h=h_central+50, $fn=100);}

		//trou général pour seringue
		translate([0,0,-5]){cylinder(r=r_central, h=20, $fn=100);}

		//trous de fixation
		translate([-30,0,-5]){cylinder(r=r_m3, h=20, $fn=100);}
		translate([30,0,-5]){cylinder(r=r_m3, h=20, $fn=100);}

		//extrusion pour accès seringue
		hull(){
			translate([0,-50,20]){rotate([-90,0,0])cylinder(r=14, h=100, $fn=100);}
			translate([0,-50,h_central-12]){rotate([-90,0,0])cylinder(r=14, h=100, $fn=100);}
			translate([-14,-50,5]){cube([28,150,20]);}	
		}
		//extrusion pour passage moteur
		hull(){
			translate([0,0,h_central+8]){rotate([-90,0,-35])cylinder(r=13, h=100, $fn=100);}
			translate([0,0,h_central-12-22]){rotate([-90,0,-35])cylinder(r=13, h=100, $fn=100);}
		}
		//allègement de la base de la pièce
		translate([0,-r_central-20,-5]){cylinder(r=15, h=h_plaque+10, $fn=200);}
		translate([0,r_central+20,-5]){cylinder(r=15, h=h_plaque+10, $fn=200);}
	}
}

module adaptateur_central(){
difference(){
		union(){
		//disque de fixation
		cylinder(r=r_central+ep+10, h=3, $fn=100);

		//jonction disque / tube
		translate([0,0,3]){cylinder(r1=r_central+ep*2+3, r2=r_central+ep*2, h=5, $fn=100);}

		//tube central
		translate([0,0,8]){cylinder(r=r_central+ep*2, h=8, $fn=100);}
		}
		//extrusion centrale générale
	translate([0,0,-5]){cylinder(r=r_central+ep, h=h_central+50, $fn=100);}

		//extrusion pour passage moteur
		rotate([0,0,45])translate([r_ext,0,-5]){cylinder(r=30, h=50, $fn=100);}

		//poursuite trou pour accès seringue
		translate([-50,0,20]){rotate([0,90,0])cylinder(r=14, h=100, $fn=100);}

		//trous de fixation à la plaque de base, trous traversant
		rotate([0,0,45])translate([-(r_central+ep+10)+2.5,0,-5]){cylinder(r=r_m3, h=h_plaque+10, $fn=50);}
		rotate([0,0,45])translate([0,-(r_central+ep+10)+2.5,-5]){cylinder(r=r_m3, h=h_plaque+10, $fn=50);}
		rotate([0,0,45])translate([0,(r_central+ep+10)-2.5,-5]){cylinder(r=r_m3, h=h_plaque+10, $fn=50);}

		//trous de fixation à la plaque de base, trous agrandis
		rotate([0,0,45])translate([-(r_central+ep+10)+2.5,0,3]){cylinder(r=r_m3+3, h=h_plaque+10, $fn=50);}
		rotate([0,0,45])translate([0,-(r_central+ep+10)+2.5,3]){cylinder(r=r_m3+3, h=h_plaque+10, $fn=50);}
		rotate([0,0,45])translate([0,(r_central+ep+10)-2.5,3]){cylinder(r=r_m3+3, h=h_plaque+10, $fn=50);}

	}
}

module gears() {
	n1 = 53; n2 = 11;
	p = fit_spur_gears(n1, n2, r_ext);
	// Simple Test:
	gear (circular_pitch=p,
		gear_thickness = 6,
		rim_thickness = 10,
		hub_thickness = 10,
hub_diameter=19,
	    number_of_teeth = n1,
bore_diameter=9,
		circles=8);
	
	translate([gear_outer_radius(n1, p) + gear_outer_radius(n2, p),0,-2.5])
	gear (circular_pitch=p,
		gear_thickness = 15,
		rim_thickness = 15,
		hub_thickness = 12,
		circles=8,
		number_of_teeth = n2,
bore_diameter=5,
		rim_width = 2);
}

module trans_gear(){ //sert à rajouter l'emplacement pour l'écrou M8 dans le grand engrenage
	difference(){
		gears();
		translate([0,0,2]){cylinder(r=7.7, h=10, $fn=6);}
	}
}

module support_seringue(){
//plutôt que d'avoir un trou à la bonne taille pour chaque seringue, travailler plutôt avec des adaptateurs interchangeables en fonction des diamètres de seringues
	difference(){
		cylinder(r=r_central-0.3, h=5, $fn=200);
		translate([0,0,-5]){cylinder(r=r_seringue+0.5, h=20, $fn=200);}
	}
}

module pousse_piston(){
	difference(){
		cylinder(r=r_central-2, h=8, $fn=100);

		translate([0,0,-5]){cylinder(r=r_piston, h=8, $fn=100);}
		translate([0,0,-5]){cylinder(r=4, h=30, $fn=100);}

		//cassage d'un coin pour laisser libre le passage moteur
		translate([-20,r_central-6,-5]){cube([50,50,20]);}	
	}
}

module rondelle(){
	difference(){
		cylinder(r=6, h=1.5, $fn=100);
		translate([0,0,-5]){cylinder(r=r_m8, h=10, $fn=100);}
	}
}

module entretoise(){
	difference(){
			cylinder(r=r_ext+2, h=20, $fn=200);

			translate([0,0,-5]){cylinder(r=r_ext-4, h=16.5+10, $fn=200);}
		//trous de fixation sur plaque du haut
		translate([0,-r_ext+2,-5]){cylinder(r=r_m3, h=h_plaque+50, $fn=50);}

		//allègement de la pièce
		rotate([0,0,45])translate([-r_ext-20,0,-5]){cylinder(r=27, h=50, $fn=200);}
		rotate([0,0,45])translate([r_ext+20,0,-5]){cylinder(r=60, h=50, $fn=200);}
		rotate([0,0,45])translate([0,r_ext+20,-5]){cylinder(r=60, h=50, $fn=200);}
		rotate([0,0,45])translate([0,-r_ext-20,-5]){cylinder(r=27, h=50, $fn=200);}

}
		
}

module complet(){
//assemblage de l'ensemble

tube_central();
translate([0,0,0]){support_seringue();}
translate([0,0,h_central+8]){rotate([180,0,90])adaptateur_central();}
translate([0,0,h_central+8]){plaque_base();}
translate([0,0,h_central+8+h_plaque]){entretoise();}
rotate([0,0,45])translate([0,0,h_central+8+h_plaque+4]){trans_gear();}
translate([0,0,h_plaque+h_central+8+25]){rotate([180,0,90])plaque_haute();}
}

module eclate(){
//vue éclatée
tube_central();
translate([0,0,10]){support_seringue();}
translate([0,0,70]){rotate([0,0,-45])pousse_piston();}
translate([0,0,h_central+8+20]){rotate([180,0,90])adaptateur_central();}
translate([0,0,h_central+8+30]){plaque_base();}
translate([0,0,h_central+8+40]){rondelle();}
rotate([0,0,45])translate([0,0,h_central+8+h_plaque+1+40]){trans_gear();}
translate([0,0,h_central+8+60]){rondelle();}
translate([0,0,h_plaque+h_central+8+17+50]){rotate([180,0,90])plaque_haute();}
}

eclate();
translate([100,0,0]){complet();}
//Pièces séparées seules
//adaptateur_central();
//tube_central();
//plaque_base();
//trans_gear();
//plaque_haute();
//support_seringue();
//rondelle();
//entretoise();
//rotate([180,0,00])pousse_piston();