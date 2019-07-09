function maximum = absmax(varargin)
%Figure out the absolute maxium of all the vectors, arrays, matrixes
%entered into the function.
%Syntax: maximum = absmax(vectors,arrays,matrixes...);
%Input: Any number of vector, arrays, matrixes.
%Output: maximum = the max value within all the entered data.

%the number of data sets entered.
num = nargin;

%Find the max
for i = 1:num
    temp = varargin{1,i};
    %disregard cell arrays and structures, give warning
    if ~iscell(temp) & ~isstruct(temp)
        while 1     %loop until the max is achieved
            %empty matrixes return 0
            if isempty(temp)
                temp = 0;
            else
                temp = max(temp);
            end
            %test if it is the abs max of this data structure
            if max(size(temp))==1   %maxed out
                maximum(1,i) = temp;
                break
            end
        end
    else
        errordlg(['absmax does not support cell arrays and structures at this time'],'Function Error');
    end
end
maximum = max(maximum);