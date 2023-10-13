clear
clc

%OPERACION
SPEED = 500; %en rpm

%MATERIAL Y FENOMENOS EJE
number_of_nodes = 7;
shear = 0;
gyro = 0;
inertia = 0;
rho = 1300;
E = 70e7 ;
Poisson = 0.29;

% Parámetros del amb


%PARAMETROS GEOMETRICOS EJE
nonlinear_decay = 0;
taper = 0;
L = 0.6;
R_out = 0.2;
R_in = 0.1;

%bearings
bearing_nodes = [number_of_nodes];
bearing_stiff = 0;
bearing_amort = 0;

% nodes_AMB = [1];
% Kx = ;
% Ky = ;
% get_pos_and_angles = [eye(number_of_nodes*4,number_of_nodes*4) zeros(number_of_nodes*4,number_of_nodes*4)];
% get_speeds = [zeros(number_of_nodes*4,number_of_nodes*4) eye(number_of_nodes*4,number_of_nodes*4)];
% get_positions = zeros(2*number_of_nodes,4*number_of_nodes);
% AMB_matrix = zeros(2*length(nodes_AMB),2*number_of_nodes);
% for i=1:2:number_of_nodes*2
%     get_positions(i,2*i-1) = 1;
%     get_positions(i+1,2*i) = 1;
%     get_pos_and_angles(i*2)
%     if ismember((i+1)/2,nodes_AMB)
%         AMB_matrix((i+1)-1,i) = 1;
%         AMB_matrix((i+1),i+1) = 1;
%     end
% end

%MODELO (saca plots automaticamente)
[model,K,M,C    ] = get_matrixes(L,number_of_nodes,shear,gyro,inertia,R_out,R_in,rho,E,Poisson,SPEED,bearing_nodes,bearing_stiff,bearing_amort);

% mascaras para obtener posiciones
mask_y = zeros(number_of_nodes*4, 1);
mask_x = zeros(number_of_nodes*4, 1);
for i=1:4:number_of_nodes*4
    mask_x(i) = 1;
    mask_y(i+1) = 1;
end

% Mascara de cómo se aplica la fuerza
force_node = 1;
force_mask_x =  zeros(number_of_nodes*4, 1);
force_mask_x(force_node*4-3)  = 1;
force_mask_y =  zeros(number_of_nodes*4, 1);
force_mask_y(force_node*4-2) = 1;

% Ganancias que modelan el AMB
w = 10.91;%*10e-3;
l = 21;%*10e-3;
mu = 4*pi*10e-7;
N = 90;
Ib = 3;
g = 0.4;
alpha = pi/4;

Ag = w*l;
k_ = N^2*mu*Ag/4;

Ky = 4*k_*Ib^2/g^3*(1+cos(alpha));
Ki = 4*k_*Ib/g^2*(1+cos(alpha));







