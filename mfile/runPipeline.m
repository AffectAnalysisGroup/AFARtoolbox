function runPipeline(video_dir,output_dir,zface_folder,FETA_folder,AU_folder,...
                     run_zface,run_FETA,run_AU_detector,create_out,varargin)

    p = inputParser;
    default_email_update     = false;
    default_email_acc_info   = [];
    default_update_iteration = -1;
    default_email_recipient  = '';
    default_debug_mode       = false;
    addOptional(p,'email_update',default_email_update);
    addOptional(p,'email_acc_info',default_email_acc_info);
    addOptional(p,'email_update_iteration',default_update_iteration);
    addOptional(p,'email_recipient',default_email_recipient);
    addOptional(p,'debug_mode',default_debug_mode);
    parse(p,varargin{:});
    email_update     = p.Results.email_update;
    email_acc_info   = p.Results.email_acc_info;
    update_iteration = p.Results.email_update_iteration;
    email_recipient  = p.Results.email_recipient;
    debug_mode       = p.Results.debug_mode;

    if create_out
        mkdir(output_dir);
    end

    if email_update
        setup_email(email_acc_info);
        if isempty(email_recipient)
            error('Email recipient address cannot be empty.');
        end
        email_subject_txt = 'A message from your running AFAR program';
    end

    [zface,FETA,AU] = initOutDir(zface_folder,FETA_folder,AU_folder,output_dir,...
                                 create_out);
    addpath(genpath('.'));

    % ZFace
    if run_zface
        zface_start_time = getMyTime();
        if debug_mode
            runZface(zface,video_dir,'debug_mode',debug_mode);
        else
            try
                runZface(zface,video_dir);
                zface_end_time = getMyTime();
                if email_update
                    email_msg_txt  = ['Zface just finished all processing at ',...
                                      zface_end_time, '\n Start time: ', ...
                                      zface_start_time, '\n Input video path: ',...
                                      video_dir,'\n Output path: ', zface.outDir];
                    sendmail(email_recipient,email_subject_txt,email_msg_txt);
                end
            catch
                zface_crash_time = getMyTime();
                if email_update
                    email_msg_txt = ['Unfortunately, zface has stopped at ',...
                                     zface_crash_time];
                    sendmail(email_recipient,email_subject_txt,email_msg_txt);
                end
            end
        end
    end


    % FETA
    load('ms3D_v1024_low_forehead.mat');
    FETA.lmSS = ':';
    FETA.res  = 200;
    FETA.IOD  = 80;
    FETA.ms3D = ms3D;
    FETA.normFeature = '2D_similarity';
    FETA.descFeature = 'HOG_OpenCV';
    FETA.patch_size  = 32;
    FETA.video_list  = getTrackingList(video_dir);
    FETA.saveNormVideo      = true;
    FETA.saveNormLandmarks  = true;
    FETA.saveVideoLandmarks = true;
    if run_FETA
        FETA_start_time = getMyTime();
        if debug_mode
            runFETA(zface,FETA,video_dir);
        else
            try
                runFETA(zface,FETA,video_dir);
                FETA_end_time = getMyTime();
                if email_update
                    email_msg_txt  = ['FETA just finished all processing at ',...
                                      FETA_end_time, '\n Start time: ', ...
                                      FETA_start_time, '\n Input video path: ',...
                                      video_dir,'\n Output path: ', FETA.outDir];
                    sendmail(email_recipient,email_subject_txt,email_msg_txt);
                end
            catch
                FETA_crash_time = getMyTime();
                if email_update
                    email_msg_txt = ['Unfortunately, FETA has stopped at ',...
                                     FETA_crash_time];
                    sendmail(email_recipient,email_subject_txt,email_msg_txt);
                end
            end
        end
    end

    % AU detection.
    AU.nAU = 12;
    AU.meanSub = false;
    if run_AU_detector
        AU_start_time = getMyTime();
        if debug_mode
            runAUdetector(video_dir,FETA,AU);
        else
            try
                runAUdetector(video_dir,FETA,AU);
                AU_end_time = getMyTime();
                if email_update
                    email_msg_txt = ['AU detection just finished all processing at',...
                                     ' ', AU_end_time, '\n Start time: ',...
                                     AU_start_time, '\n Input video path: ',...
                                     video_dir,'\n Output path: ', AU.outDir];
                    sendmail(email_recipient,email_subject_txt,email_msg_txt);
                end
            catch
                AU_crash_time = getMyTime();
                if email_update
                    email_msg_txt = ['Unfortunately, AU detection has stopped at ',...
                                     AU_crash_time];
                    sendmail(email_recipient,email_subject_txt,email_msg_txt); 
                end
            end
        end
    end
end



