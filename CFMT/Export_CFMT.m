%% Export CFMT Files
%  Daniel Elbich
%  Laboratory of Developmental Neuroscience
%  3/19/15

%  Readings in CFMT Files and exports individual CSV files and summary
%  file.
%
%  Update 11/2016
%  Now

%% Code
%Final Matrix Setup Cambridge
final = {'Subject ID' 'Date' 'Short Form Accuracy Raw'...
    'Short Form Accuracy Percent' 'Long Form Accuracy Raw'...
    'Long Form Accuracy Percent' 'Block 1 Correct RT' ...
    'Block 2 Correct RT' 'Block 3 Correct RT' 'Block 4 Correct RT' ...
    'Total Correct RT Short Form' 'Total Correct RT Long Form'...
    'Block 1 Raw Total' 'Block 2 Raw Total' 'Block 3 Raw Total'...
    'Block 4 Raw Total' };
block = {'block1' 'block2' 'block3' 'block4'};

task = {'Male' 'Female' 'Car'};

m_count=0;
f_count=0;

for a=1:length(names)
    %% Debug
    %check='CMTF_results_SD_9b_040_Female_6-6-13.txt';
    
    %a=1;
    %names{1,1}=check;
    
    %fid=fopen(check);
    
    %% Working Calculation
    fid=fopen(names{a,1});
    data = textscan(fid,'%s','Delimiter','\n');
    tempcsv = cell(150,7);
    
    
    for z=1:length(data{1,1})
        
        limbo=strsplit(data{1,1}{z,1},'\t');
        
        for p=1:length(limbo)
            
            tempcsv{z,p}=limbo{1,p};
            
        end
        clear limbo;
    end
    
    
    %Locate Practice Sessions
    index=7;
    
    while strcmpi(tempcsv(index,7),tempcsv(index+1,7))==1
        index=index+1;
    end
    
    %Starting index for actual task
    index=index+1;
    
    
    %Create task indices
    startindex.block1=index;
    startindex.block2=index+23;
    startindex.block3=index+58;
    startindex.block4=index+87;
    
    endindex.block1=index+17;
    endindex.block2=index+52;
    endindex.block3=index+81;
    endindex.block4=index+116;
    
    
    tempRT=str2double(tempcsv);
    
    k = strfind(tempcsv{3,2}, 'SD');
    l = strfind(tempcsv{3,2}, 'SF');
    
    taskcheck=strfind(tempcsv{1,1}, 'Car');
    if taskcheck==1
        taskname='Car_Cambridge';
    else
        taskcheck=strfind(tempcsv{7,2}, 'p1.jpeg');
        if taskcheck==1
            taskname='Female_Cambridge';
        else
            taskname='Male_Cambridge';
        end
    end
    
    %(23,1)
    
    
    %Start Header info
    try
        final{a+1,1} = tempcsv{3,2}(k:k+8);
    catch
        final{a+1,1} = tempcsv{3,2};
    end
        
        
    if k == 0
        final{a+1,1} = tempcsv{3,2}(l:l+8);
    elseif isempty(k) == 1 || isempty(l) == 1
        final{a+1,1} = tempcsv{3,2};
    end
    
    final{a+1,2} = tempcsv{2,2};
    %final{a+3,1} = tempcsv{2,2};
    
    
    %Recording Accuracy
    %Short Form
    final{a+1,3}=tempRT(index+20,1)+tempRT(index+55,1)+tempRT(index+84,1);
    final{a+1,4}=(final{a+1,3}/72)*100;
    
    %Long Form
    final{a+1,5}=tempRT(index+20,1)+tempRT(index+55,1)+tempRT(index+84,1)+tempRT(index+119,1);
    final{a+1,6}=(final{a+1,5}/102)*100;
    
    
    %Caluclate Mean RTs
    tempblock.(block{1,1}) = tempRT(startindex.block1:endindex.block1,3:6);
    tempblock.(block{1,2}) = tempRT(startindex.block2:endindex.block2,3:6);
    tempblock.(block{1,3}) = tempRT(startindex.block3:endindex.block3,3:6);
    tempblock.(block{1,4}) = tempRT(startindex.block4:endindex.block4,3:6);
    
    for y=1:length(block)
        
        count=1;
        
        for x=1:length(tempblock.(block{1,y}))
            if tempblock.(block{1,y})(x,4) == 1
                correctedRT.(block{1,y})(count,1)=tempblock.(block{1,y})(x,1);
                count=count+1;
            end
        end
    end
    
    %Mean RT
    totalRTshort = [correctedRT.(block{1,1}); correctedRT.(block{1,2}); correctedRT.(block{1,3})];
    if isfield(correctedRT, (block{1,4}))
        totalRTlong = [correctedRT.(block{1,1}); correctedRT.(block{1,2}); correctedRT.(block{1,3}); correctedRT.(block{1,4})];
    else
        correctedRT.(block{1,4}) = NaN;
        totalRTlong = NaN;
    end
    
    %Averages
    final{a+1,7} = mean(correctedRT.(block{1,1}));
    final{a+1,8} = mean(correctedRT.(block{1,2}));
    final{a+1,9} = mean(correctedRT.(block{1,3}));
    final{a+1,10} = mean(correctedRT.(block{1,4}));
    final{a+1,11} = mean(totalRTshort);
    final{a+1,12} = mean(totalRTlong);
    
    %Raw Block Totals
    final{a+1,13}=tempRT(index+20,1);
    final{a+1,14}=tempRT(index+55,1);
    final{a+1,15}=tempRT(index+84,1);
    final{a+1,16}=tempRT(index+119,1);
    
    %Raw Scores Overall
    aa=17;
    count=0;
    for aaa=1:102
        switch aaa
            case 1
                block1=startindex.block1;
                iter=0;
            case 19
                block1=startindex.block2;
                iter=0;
            case 49
                block1=startindex.block3;
                iter=0;
            case 73
                block1=startindex.block4;
                iter=0;
        end
        
        %final{1,aa+count}={};
        final{a+1,aa+count}=cell2mat(tempcsv(block1+iter,6));
        count=aaa;
        iter=iter+1;
        %count=count+1;
    end
    
    
    
    %% Global Accuracy Across trial
    
    %Create New Matrix
    b=tempRT;
    %b(:,1:2)=[];
    %b(:,5)=[];
    
    %Eliminate Rows
    if strcmpi(tempcsv{9,7},tempcsv{10,7})==1
        b(1:3,:)=[];
    end
    
    %Elminate misc information from data matrix (e.g. block accuracies)
    b(1:6,:)=[];
    b(22:26,:)=[];
    b(52:56,:)=[];
    b(76:80,:)=[];
    b(106:end,:)=[];
    b(1:3,:)=[];
    
    %Count for Male/Female trials
    if names{a,2}==1
        m_count=m_count+1;
    else
        f_count=f_count+1;
    end
    
    for xx=1:102
        if a==1 && xx==1
            ind_trials{1,1} = 'Trial';
            ind_trials{1,2} = 'Target';
            ind_trials{1,3} = 'Percent_Correct';
            
            subj_ind_trials{1,1} = 'Trial';
            subj_ind_trials{1,2} = 'Target';
            
        end
        
        if xx==1
            subj_ind_trials{1,a+2} = final{a+1,1};
        end
        
        
        if a==1
            ind_trials{xx+1,1} = ['Trial_' num2str(xx)];
            ind_trials{xx+1,2} = b(xx,5);
            ind_trials{xx+1,3} = b(xx,6);
            
            subj_ind_trials{xx+1,1} = ['Trial_' num2str(xx)];
            subj_ind_trials{xx+1,2} = b(xx,5);
            subj_ind_trials{xx+1,3} = b(xx,6);
            
        else
            ind_trials{xx+1,3} = ind_trials{xx+1,3}+b(xx,6);
            
            subj_ind_trials{xx+1,a+2} = b(xx,6);
            
        end
        
        if a==length(names)
            ind_trials{xx+1,3} = (ind_trials{xx+1,3}/a);
        end
        
        
        
        if names{a,2}==1
            
            if m_count==1 && xx==1
                m_ind_trials{1,1} = 'Trial';
                m_ind_trials{1,2} = 'Target';
                m_ind_trials{1,3} = 'Percent_Correct';
            end
            
            if m_count==1
                m_ind_trials{xx+1,1} = ['Trial_' num2str(xx)];
                m_ind_trials{xx+1,2} = b(xx,5);
                m_ind_trials{xx+1,3} = b(xx,6);
            else
                m_ind_trials{xx+1,3} = m_ind_trials{xx+1,3}+b(xx,6);
            end
            
        else
            
            if f_count==1 && xx==1
                f_ind_trials{1,1} = 'Trial';
                f_ind_trials{1,2} = 'Target';
                f_ind_trials{1,3} = 'Percent_Correct';
            end
            
            if f_count==1
                f_ind_trials{xx+1,1} = ['Trial_' num2str(xx)];
                f_ind_trials{xx+1,2} = b(xx,5);
                f_ind_trials{xx+1,3} = b(xx,6);
            else
                f_ind_trials{xx+1,3} = f_ind_trials{xx+1,3}+b(xx,6);
            end
            
        end
        
        if a==length(names)
            m_ind_trials{xx+1,3} = (m_ind_trials{xx+1,3}/m_count);
            f_ind_trials{xx+1,3} = (f_ind_trials{xx+1,3}/f_count);
        end
        
    end
    
    
    
    %nameexport=final{z+1,1};
    %cell2csv([final{a+1,1} '_' taskname '.csv'],tempcsv);
    
    %check=fopen([final{a+1,1} '_' taskname '.csv'],'w');
    %fprintf(check, '%s', tempcsv{1,1});
    
    %fclose(check);
    
    %% Clear vars for next loop
    clear tempblock correctedRT totalRT tempRT tempcsv;
    
end

cell2csv(['summary_' taskname '.csv'],final);
cell2csv(['summary_' taskname 'Ind_Trials.csv'],ind_trials);


fclose all;
