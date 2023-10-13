function model = blade_model(L,nonlinear_decay, number_of_nodes, shear, gyro,inertia,asym,taper,rigid,rotate,NX,max_out,max_in,min_out,min_in,rho,E,Poisson,axial_force,number_crit,kbearing,cbearing,bearing_nodes)
    nodes = [];
    G  = E/2*(1+Poisson);

    type = [shear inertia gyro];

    shaft_types = [0 0 1; 1 1 1; 1 1 0; 1 0 1; 0 1 1; 1 0 0; 0 1 0; 0 0 0];
    shaft_type = 0;
    for i=1:8
        if shaft_types(i,:) == type
            shaft_type = i;
        end
    end
    
    diff_out = max_out-min_out;
    diff_in = max_in-min_in;
    ancho_out_nonlinear=[];
    ancho_in_nonlinear=[];
    
    ponder = [];
    for i=1:number_of_nodes
        nodes = [nodes;i (i-1)*L/(number_of_nodes-1)];
        ancho_out_nonlinear = [ancho_out_nonlinear max_out-diff_out*0.6^(number_of_nodes-i)];
        ancho_in_nonlinear = [ancho_in_nonlinear max_in-diff_out*0.6^(number_of_nodes-i)];
    end
    
    if nonlinear_decay
        ancho_out = ancho_out_nonlinear;
        ancho_in = ancho_in_nonlinear;
    else
        ancho_out = linspace(max_out,min_out,number_of_nodes);
        ancho_in = linspace(max_in,min_in,number_of_nodes);
    end
    
    model.node = nodes;
    
    %%% Modelamiento del eje %%%
    
    shafts = [];
    if taper
        shaft_type = shaft_type+20;
        for i=1:number_of_nodes-1
            shafts =[shafts; shaft_type i i+1 ancho_out(1,i) ancho_out(1,i+1) ancho_in(1,i) ancho_in(1,i+1) rho E G axial_force];
        end
    else
        for i=1:number_of_nodes-1
            shafts =[shafts; shaft_type i i+1 ancho_out(1,i) ancho_in(1,i) rho E G axial_force];
        end
    end
    
    %%% Modelamiento discos y fuerzas
    discs = [];
    forces = [];
    
    %%% Modelamiento rotores
    bearings = [];
    if rigid
        bearings = [1 number_of_nodes];
    else
        if kbearing ~= 0
            for i=1:length(bearing_nodes)
                bearings = [bearings; 3 bearing_nodes(i) kbearing kbearing cbearing cbearing];
            end
        end
    end
    
    %%% Generación del modelo completo
    model.shaft = shafts;
    model.disc = discs;
    model.bearing = bearings;
    model.force = forces;
    model_graph(model,NX,number_crit,1)

end