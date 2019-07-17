% This file evaluates the continous for of a boolean function over values in "X",

% Inputs:
%   FunctionArray: A single boolean function or an array of K functions with each FunctionArray(k,:,:) corresponding to
%   one signle function. The function is encoded like:
%   F = [5 6 0 0 ; -3 0 0 0 ; 0 0 0 0 ; 0 0 0 0]
%   with each row corresponding inputs of one OR, and all the OR outputs then connected with an
%   AND together, and zeros denoting the unused inputs. Hence, the above example
%   would be interpreted as:
%   F = (Gene5 OR Gene6) AND (NOT Gene3)
%   Additionally we see that F is from a family of functions with maximum 4 inputs in ORs(number of columns)
%   and 4 inputs to the ANDs(number of rows).
%
%   X: This is the gene data matrix. Each row corresponds to one gene, and
%   each column is one sample. Matrix is assumed to be continuous.
%

% Otputs:
%   Result: A K times N binary matrix reporting the F(X) with each row corresponding to
%   FunctionArray(k,:,:) and each column corrsponding to a sample(i.e. X(:,n)).

% Written By Pejman, 26June2014, Basel
% Pejman.m@gmail.com
%----------------------------------------------

function [Result] = Evaluate_FunctionCnt_pANDORRA(FunctionArray ,X)
global Consts

% mir -> mir*
X= X*Consts.mirScale.A0./Consts.mirScale.Kd;

if length(size(FunctionArray))==2
    %% It's a Single function, format it into an 3D array of length one.
    tmpFnc = FunctionArray;
    clear FunctionArray
    FunctionArray(1,:,:) = tmpFnc;
    clear tmpFnc
end
MaxAnd = size(FunctionArray,2); % Number of AND inputs in the function family
N      = size(X,2);             % Number of Samples in the data.

for K = size(FunctionArray,1):-1:1
    RowValues  = zeros(MaxAnd, N);
    Function(:,:) = (FunctionArray(K,:,:));
    Fpos = max(0,Function); % The OR  part
    Fneqs = Function(:)<0;  % The NOT part
    %% handle the OR part
    for i = 1:MaxAnd
        Filt = Fpos(i,:)>0;
        if any(Filt)
            selMir= Function(i, Filt);
            RowValues(i,:)= F1_Kd(X(selMir,:),Consts.Kd.OR(selMir),repeats.OR(selMir));
        end
    end
    ff4_lacI_act= F2(sum(RowValues,1), Consts.Continuous_Circuit_F2C, Consts.Continuous_Circuit_Tmax);
    mirFF4= Consts.Continuous_Circuit_FF4max*ff4_lacI_act;
    lacI= Consts.Continuous_Circuit_LacImax*ff4_lacI_act;
    %% handle the NOT part
    selMir= -Function(Fneqs);
    Result(K,:)= Consts.Continuous_Circuit_OUTmax * ...
      F1_Kd([lacI;mirFF4;X(selMir,:)],[Consts.Kd.LacI;Consts.Kd.NOT_FF4;Consts.Kd.NOT(selMir)],...
            [1;repeats.NOT_FF4;repeats.NOT(selMir)]);
end
end

function Y= F1_Kd(X,Kd,repeats)
% X [miR]x[samples]
% Kd [miR]
% repeats [miR]
% repeats: How many times the miR target site repeats
  n= size(X,2);
  S= sum(repmat(repeats.*Kd,1,n)./(repmat(Kd,1,n)+X));    % [miR]x[samples]
  Y= S - (sum(repeats)-1);
end

function Y = F2(X, Continuous_Circuit_F2C, Continuous_Circuit_Tmax)
Y = X./(X+Continuous_Circuit_F2C/Continuous_Circuit_Tmax);
end
