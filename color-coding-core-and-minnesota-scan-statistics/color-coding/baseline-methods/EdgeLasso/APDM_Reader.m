function [p_value,edges,label] = APDM_Reader(fileName)
fid=fopen(fileName);
tline = fgetl(fid);
p_value=[];
label=[];
edges={};

while ischar(tline)
    if strncmp(tline,'#',1)
        tline = fgetl(fid);
        continue;
    elseif strstartswith(tline,'NodeID')
        while(true)
            tline = fgetl(fid);
            if ~strstartswith(tline,'END')
                str=strsplit(' ',tline,'omit');
                p_value=[p_value str2num(str{2})];
            else
                break
            end            
        end
    elseif strstartswith(tline,'EndPoint0')
         index=1;
         while(true)
            tline = fgetl(fid);
            if ~strstartswith(tline,'END')
                str=strsplit(' ',tline,'omit');
                edges{index}(1)=str2num(str{1});
                edges{index}(2)=str2num(str{2});
                index=index+1;
            else
                break
            end            
         end
    elseif strstartswith(tline,'SECTION4')
         fgetl(fid);
         index=1;
         while(true)
            tline = fgetl(fid);
            if ~strstartswith(tline,'END')
                str=strsplit(' ',tline,'omit');
                label=[label str2num(str{1})+1];
                index=index+1;
            else
                break
            end            
        end
    else
        tline = fgetl(fid);
        continue
    %disp(tline)
    end
end
fclose(fid);