function z = importer_lorenz(filename, dataLines)
%IMPORTFILE Import data from a text file
%  Z = IMPORTFILE(FILENAME) reads data from text file FILENAME for the
%  default selection.  Returns the numeric data.
%
%  Z = IMPORTFILE(FILE, DATALINES) reads data for the specified row
%  interval(s) of text file FILENAME. Specify DATALINES as a positive
%  scalar integer or a N-by-2 array of positive scalar integers for
%  dis-contiguous row intervals.
%
%  Example:
%  z = importfile("C:\Users\HowarthKevin\Documents\GitHub\high-order-and-chaos\lorenz\Simulated Solutions\GLRK(4)_u_0.01.txt", [1, Inf]);
%
%  See also READTABLE.
%
% Auto-generated by MATLAB on 15-Mar-2021 19:51:06

%% Input handling

% If dataLines is not specified, define defaults
if nargin < 2
    dataLines = [1, Inf];
end

%% Set up the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 3);

% Specify range and delimiter
opts.DataLines = dataLines;
opts.Delimiter = "\t";

% Specify column names and types
opts.VariableNames = ["Var1", "Var2", "VarName3"];
opts.SelectedVariableNames = "VarName3";
opts.VariableTypes = ["string", "string", "double"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Specify variable properties
opts = setvaropts(opts, ["Var1", "Var2"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["Var1", "Var2"], "EmptyFieldRule", "auto");

% Import the data
z = readtable(filename, opts);

%% Convert to output type
z = table2array(z);
end