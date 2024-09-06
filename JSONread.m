% the general purpose JSON file
function [hlink,imgfile,IsApproved,IsSuspended,TEvents,TAnnouncements]=JSONread(flag)
try
      %if local file use
       % fname = 'meta_data.json';
       % if file is in share point site
       fname="C:\Users\skeshavm\MATLAB Drive\meta_data.json";
       % fid = fopen(fname,'r+'); 
       %For remote locations scheme_name://path_to_file/my_file.ext
        %scheme_name for azure blob wasb, wasbs
        %scheme name for AWS is  s3
        %scheme_name for hdfs is 	hdfs
        %for folder name 'C:\myFolder\myFile.sample_file.txt'
        finfo=dir(fname);
        creationDateNum = finfo.datenum;
        creationDate = datetime(creationDateNum, 'ConvertFrom', 'datenum');
        currentDate = datetime('now');
        datebal=currentDate-creationDate;
        

        raw=fileread(fname,"Encoding","Shift_JIS");
        
        str=raw;
        
        validDays=20;
        
        
        val = jsondecode(str);
        % validDays=val.validDays;
        IsApproved = val.IsApproved;
        IsSuspended = val.IsSuspended;
        EventsTable=table();
        if(datebal>days(validDays))
            IsApproved=false;
            val.IsApproved=false;
        end
        TE=cell2table(val.Events);
        TA=struct2table(val.Announcements);
        n=numel(TE);
        
        for i=1:n-1
            EventsTable.Date=TE(i,:).Var1{1}.Date;
            EventsTable.Event=TE(i,:).Var1{1}.EventName;
            EventsTable.link=TE(i,:).Var1{1}.Recording;
        
        
        end
        TEvents=EventsTable;
        TAnnouncements=TA;
        hlink.Text1 = 'LatestEvent';
        hlink.URL1 = 'https://content.mathworks.com/viewer/6335b66c9ae2f5a75fa14e4b';
        hlink.Text2 = 'LatestEvent';
        hlink.URL2 = 'https://content.mathworks.com/viewer/6335b66c9ae2f5a75fa14e4b';
        imgfile=TE(3,1).Var1{1}.DisplayImage;
        
        flag=true;
        imgfile="GMSplashScreenBackground.png";
        hlink.imagefile=imgfile;
        
        % val.isSuspended=flag;
        %jsonencode(val);
        % fprintf(fname,'%s', val)
        % fclose(fname);
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
