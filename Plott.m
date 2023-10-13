%Generación de modelos y gráficos para la tarea 1 de int. electromec.
L = 0.6;
nonlinear_decay = 0;
number_of_nodes = 8;
shear = 1;
gyro = 1;
inertia = 0;
asym = 0;
taper = 0;
rigid = 0;
rotate = 1;
NX = 1;
max_out = 0.02;
max_in = 0;
min_out = max_out;
min_in = max_in;
rho = 7850;
E = 190e9;
Poisson = 0.29;
axial_force = 0;
number_crit = 10;

%SI K ES CERO NO SE PONEN BEARINGS
kbearing = 40*10e6;%40*10e6
cbearing = 0;
bearing_nodes = [1,number_of_nodes]
blade_model(L,nonlinear_decay, number_of_nodes, shear, gyro,inertia,asym,taper,rigid,rotate,NX, ...
                     max_out,max_in,min_out,min_in,rho,E,Poisson,axial_force,number_crit,kbearing,cbearing,bearing_nodes)




