% the general purpose JSON file
function [hlink,imgfile,IsApproved,IsSuspended,TE,TA,resizeParams]=JSONread(flag)
try
      %if local file use
       % fname = 'meta_data.json';
       % if file is in share point site please replace this with your file
       % name
       % location make sure all data used are in the same location
       fname="C:\Users\skeshavm\MATLAB Drive\meta_data.json";
       % fid = fopen(fname,'r+'); 
       %For remote locations scheme_name://path_to_file/my_file.ext
        %scheme_name for azure blob wasb, wasbs
        %scheme_name for hdfs is 	hdfs
        %for folder name 'C:\myFolder\myFile.sample_file.txt'
        finfo=dir(fname);
        creationDateNum = finfo.datenum;
        creationDate = datetime(creationDateNum, 'ConvertFrom', 'datenum');
        currentDate = datetime('now');
        datebal=currentDate-creationDate;
       % resizeParams=[378 448];
        resizeParams=[450 550];
        raw=fileread(fname,"Encoding","Shift_JIS");
        
        str=raw;
        %line 26 is for testing please remove it in production
          val = jsondecode(str);
      
        
        
        val = jsondecode(str);
        validDays=val.validDays;
        repopup=val.popbackduration;
        %IsApproved = val.IsApproved;
        % validDays=val.validDays;
        IsApproved = val.IsApproved;
        %please chnage this line to use commented line as this flag is set
        %for testing. 
        IsSuspended =0;  %val.IsSuspended;
        EventsTable=table();
        if(datebal>days(validDays)|datebal<days(repopup))
            IsApproved=false;
            val.IsApproved=false;
        end
        TE=cell2table(val.Events);
        TA=struct2table(val.Announcements);
        n=height(TE);
        
        for i=1:n-1
            EventsTable.Date=TE(i,:).Var1{1}.Date;
            EventsTable.Event=TE(i,:).Var1{1}.EventName;
            EventsTable.link=TE(i,:).Var1{1}.Recording;
        
        
        end


        %latest event is a tag for us to pick the latest event, this has to
        %be the first event in the table.
        hlink.Text1 = 'LatestEvent';
       
        imgfile=TE(3,1).Var1{1}.DisplayImage;
         TE=EventsTable;
        flag=true;
        hlink.imagefile=imgfile;
       
        % val.isSuspended=flag;
        %jsonencode(val);
        % fprintf(fname,'%s', val)
     %
catch Me
        disp(getReport(Me));
        flag=false;
        imgfile="GMSplashScreenBackground.png";
        hlink.Text1 = 'LatestEvent';
        hlink.URL1 = 'https://content.mathworks.com/viewer/6335b66c9ae2f5a75fa14e4b';
        hlink.Text2= 'LatestEvent';
        hlink.URL2= 'https://www.gm.com/';
        IsApproved = 1;
        IsSuspended=1;
        val.isSuspended=flag;
        TEvents=0;
        TAnnouncements=0;


end
