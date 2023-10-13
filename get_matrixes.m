function [model,K,M,C] = get_matrixes(L,number_of_nodes,shear,gyro,inertia,R_out,R_in,rho,E,Poisson,speed,bearing_nodes,bearing_stiff,bearing_amort)
    axial_force = 0;
    G  = E/2*(1+Poisson);

    %SE ASUMEN BEARINGS SIMETRICOS
    cxx = bearing_amort;
    cyy = cxx;
    kxx = bearing_stiff;
    kyy = kxx;

    %GET SHAFT TYPE
    type = [shear inertia gyro];
    shaft_types = [0 0 1; 1 1 1; 1 1 0; 1 0 1; 0 1 1; 1 0 0; 0 1 0; 0 0 0];
    shaft_type = 0;
    for i=1:8
        if shaft_types(i,:) == type
            shaft_type = i;
        end
    end
    
    %NODOS
    nodes = [];
    for i=1:number_of_nodes
        nodes = [nodes;i (i-1)*L/(number_of_nodes-1)];
    end
    model.node = nodes;
    
    %%% Modelamiento del eje %%%
    shafts = [];
    for i=1:number_of_nodes-1
        shafts =[shafts; shaft_type i i+1 R_out R_in rho E G axial_force];
    end
    
    %%% Modelamiento discos y fuerzas
    discs = [];
    forces = [];
    
    %%% Modelamiento rodamientos
    bearings = [];
    for i=1:length(bearing_nodes)
        bearings = [bearings; 3 bearing_nodes(i) kxx kyy cxx cyy ];
    end

    %%% Generación del modelo completo
    model.shaft = shafts;
    model.disc = discs;
    model.bearing = bearings;
    model.force = forces;
    
    [M0,C0,C1,K0,K1] = rotormtx(model);
    [Mb,Cb,Kb] = bearmtx(model,speed);

    M = M0 + Mb;
    K = K0 + Kb + speed*K1;
    C = C0 + Cb + speed*C1;
end