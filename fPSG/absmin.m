function minimum = absmin(varargin)
%Figure out the absolute minimum of all the vectors, arrays, matrixes
%entered into the function.
%Syntax: minimum = absmin(vectors,arrays,matrixes...);
%Input: Any number of vector, arrays, matrixes.
%Output: min = the min value within all the entered data.

%the number of data sets entered.
num = nargin;

%Find the min
for i = 1:num
    temp = varargin{1,i};
    %disregard cell arrays and structures, give warning
    if ~iscell(temp) & ~isstruct(temp)
        while 1     %loop until the min is achieved
            %empty matrixes return 0
            if isempty(temp)
                temp = 0;
            else
                temp = min(temp);
            end
            %test if it is the abs max of this data structure
            if max(size(temp))==1   %reached absmin out
                minimum(1,i) = temp;
                break
            end
        end
    else
        errordlg(['absmin does not support cell arrays and structures at this time'],'Function Error');
    end
end
minimum = min(minimum);