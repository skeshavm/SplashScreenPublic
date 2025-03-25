if usejava('desktop')
        fprintf('Non-Silent mode:  Running file %s\n', mfilename("fullpath"))
       %Get all the startup files
    all_startups = which('startup.m', '-all');
   if(length(all_startups)==1)

        splash_screen;

   end

    %if there is more than one startup file
    % this is setup such that we do not hit infinite loop
    %get a list of all startup files
    startup_file={};
   this_startup_file = string(mfilename('fullpath'));
    for i=1: length(all_startups)
         startup_file{i}=string(all_startups{i});
    end
  if length(all_startups) > 1

    %Get the startup 1st and 2nd on the path

    first_startup_file = all_startups{1};

    second_startup_file =  startup_file{2};


    %If this file is NOT the 2nd startup file

    %NOTE:  Don't want infinite loop!!

        if  isequal(first_startup_file, this_startup_file)

        %Run the 2nd startup
            defaultstartupisfirst=false;
        else
            defaultstartupisfirst =true;
        end 
     if(defaultstartupisfirst)
         splash_screen;
     else
         splash_screen;
         run(first_startup_file);
        
     end


end  %if length(...

else
    fprintf('Silent mode:  Running file %s\n', mfilename("fullpath"))
end




