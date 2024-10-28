function splash_screen()
    flag=1;
    [hlink,imgfile,IsApproved,IsSuspended,TE,TA,resizeParams] =JSONread(flag)
    %check if it is approved or flagged for no show or date has expired
    if(flag==false)
    return;
    end
    if isfile("Status.mat") 
    load("status.mat");
    else
    flag=1;
    end;
    if(flag==0)
    
    return;
    end
    
        if (flag==0)
        
        end
    IsSuspended=0;
        if IsApproved == 0
            return; % Exit the script silently if the content is not approved
        end
        if IsSuspended ==1
          return;
        end
        %load the image file for splash screen
        if(flag)
            image_file=hlink.imagefile;
            % web_link=hlink.URL1;
        else
            image_file=  imgfile;
            %web_link=hlink.URL1;
        end
    
    img = imread(image_file);
    
    %get image size 
    
    tfig_pos(3)=560;
    tfig_pos(4)=420;
    
    % Create a figure that's invisible at first
    screenSize = get(0, 'ScreenSize'); % This returns [left, bottom, width, height]
    screenWidth = screenSize(3);
    screenHeight = screenSize(4);
      % this scaling needs be fixed as it keeps it below full screen.
    SplashImageRatioX=0.8;
    SplashImageRatioY=0.9;
    % Define the splash screen size (you can adjust these values)
    splashWidth = min( tfig_pos(3), screenWidth);
    splashHeight = min(tfig_pos(4), screenHeight);
    imresize(img,[splashWidth,splashHeight]);
    % Calculate the position to center the splash screen
    posX = (screenWidth - splashWidth) / 2;
    posY = (screenHeight - splashHeight) / 2;
    
    
    tempFig = uifigure('Units', 'normalized', 'Position', [0 0 0.1 0.1], 'Visible', 'off');
    %drawnow; % Ensure the figure is created
    
    % Get the position of the temporary figure
    guiPosition = get(tempFig, 'Position');
    
    % Close the temporary figure
    close(tempFig);
    
    % Calculate the position of the new figure
    newFigPosition = [0, 0, splashWidth, splashHeight];
    
    % Create the new figure on the same screen as the MATLAB GUI
    %this need s to hardcoded as is not expected to change
    fig = uifigure('Visible', 'off', 'Menubar', 'none', 'Toolbar', 'none', 'Name', 'GM & MATHWORKS', 'NumberTitle', 'off', 'Resize', 'off','Position',newFigPosition);
    fig_position = get(fig, 'Position')
    set(fig, 'Units', 'pixels');
    set(fig,'Visible','on');
     % Read and display the image
     %this isze needs to be hardcpded to keep the image size same for all
     %machines. 
    img1= imresize(img,resizeParams);
    
    im=uiimage(fig,"ImageSource",img,"ScaleMethod",'scaledown', 'Position',[0 0 splashWidth* SplashImageRatioX, splashHeight* SplashImageRatioY]);
      
    
       im_position = get(im, 'Position')
    
    drawnow
    
    %% Need Help Buttons and Links
    % Create a clickable text that opens the web link
    % this link needs to be kept constant  for the help link is the same.
    web_link= "https://www.mathworks.com/help/?s_tid=gn_supp";
    p3 =  uibutton(fig,'text','MathWorks Help', ...
        'Position', [0.58*splashWidth, 0.01*splashHeight,130, 30],"ButtonPushedFcn",@(src,event)openlink());
    
    % movegui(fig,'northeast')
    
    function openlink()
         web(web_link);
        end
    
    drawnow;
    NA=height(TA)-1;
    NE=height(TE);
    
    
        % Define your text and its properties
        %This Updates MathWorks information
    for i=1:NA
        hlink1=uihyperlink(fig);
        hlink1.FontColor=[0.9 0.9 0.9];
        hlink1.FontSize=12;
        hlink1.Text= string( TA(1,:).EventName{i});
        hlink1.URL=  TA(1,:).Recording{i};
        size = hlink1.Position(3:4);
        hloc=0.33/i;
        p=100+int16(60/i);
        hlink1.Position=[ 0.2*splashWidth hloc*splashHeight p 200]; 
            set(fig, 'Visible', 'on');
    end
    i=0;
    for i=1:NE
        hlink2=uihyperlink(fig);
        hlink2.FontColor=[0.9 0.9 0.9];
        hlink2.FontSize=12;
        hlink2.Text= string( TE(i,:).Event);
        hlink2.URL=  TE(i,:).link;
        size = hlink2.Position(3:4);
        hloc=0.33/i;
        p=100+int16(60/i);
        hlink2.Position=[ 0.6*splashWidth hloc*splashHeight p 200]; 
            set(fig, 'Visible', 'on');
    end
    
        set(fig, 'Visible', 'on');
        movegui(fig, 'center');
        
        % Now make it visible
        set(fig, 'Visible', 'on');
        
        % Wait for the figure to be closed
        %uiwait(fig);
        flag=1;
    end