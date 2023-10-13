function model_graph(model,NX,number_crit,campbell)  
    %%% vista del modelo con componentes
    p = 1
    figure(p)
    p = p+1
    picrotor(model);
    title("Modelo del eje")
    

    if campbell
        rotor_spd = 0:100:6000
        rot_spd_rad = 2*pi*rotor_spd/60
        [eigenvalues,eigenvectors,kappa,eccentricity] = chr_root(model,rotor_spd);

        figure(p)
        p=p+1
        plotcamp(rot_spd_rad,eigenvalues,NX,0,kappa);
        title("Gráfico de Campbell")
    end
    %%% Muestra de velocidades críticas
    
    [critical_speeds,mode_shape] = crit_spd(model,NX,0,number_crit);
    %critical speeds es dado en radianes, pero en el resto de las cosas es rpm
    %chr root recibe valores de velocidad en rad/s no en rpm
    
    
    disp("Las velocidades críticas en rad/seg son:")
    disp(critical_speeds)
    disp("Las velocidades críticas en rpm son:")
    disp(critical_speeds/(2*pi)*60)
    
    %disp(critical_speeds(get_crit_speed)/(2*pi)*60); %en rpm



    %%%%%% Gráfico de los modos de vibración %%%%%%%%%

    
    
    %%% PARTE QUE HAY QUE ARREGLAR PARA QUE FUNCIONE CON MODE_SHAPE
    %%% la idea es indexar por critical speed y usar el vector
    %%% correspondiente en mode_shape

    %%% en el manual sale esto

    % [] = plotmode(model,Mode,eigenvalue)
    % where Mode is the mode or ODS to plot. Note that this must be a vector and so only one
    % mode may be plotted at a time. The inclusion of the eigenvalue is optional; if included then
    % this will be included on the plot as the natural frequency in Hz (the eigenvalue is given in
    % rad/s).

    %%% Entonces los modos se verán igual porque dependen de las propiedades del aspa, de nada más,
    %%% al incluir el eigenvalue (o velocidad crítica) se agrega la frecuencia natural en rad/s
    %%% asociada a ese modo
    for get_crit_speed=1:number_crit
            [eigenvalues,eigenvectors] = chr_root(model,critical_speeds(get_crit_speed));
            figure(p)
            plotmode(model,mode_shape(:,get_crit_speed),eigenvalues(get_crit_speed));
            title(sprintf("Modo de oscilación de la velocidad crítica %f rpm",critical_speeds(get_crit_speed)/(2*pi)*60))
            p = p+1;
            disp( sprintf("Magnitud de oscilación del nodo 8 para la velocidad crítica %f",critical_speeds(get_crit_speed)/(2*pi)*60))
            disp(abs(mode_shape(8,get_crit_speed)));
    %plotmode(model,mode_shape(:,get_mode),eigenvectors(get_mode));
    
    
end