% BinaryReader ReaderBinary = new BinaryReader(fs);
% ushort nRows = ReaderBinary.ReadUInt16();
% ushort nCols = ReaderBinary.ReadUInt16();
% double zMin = ReaderBinary.ReadDouble();
% 
% ushort len = ReaderBinary.ReadUInt16();
% 
% char[] imFile = ReaderBinary.ReadChars((int)len);
% 
% p_mModel3D.ModelExpression = p_mModel3D.ModelFileName.Substring(6);
% 
% uint dataLen = ReaderBinary.ReadUInt32();
% 
% uint oneRead = dataLen / 5;
% 
% double[] X = new double[oneRead];
% double[] Y = new double[oneRead];
% double[] Z = new double[oneRead];
% double[] RangeX = new double[oneRead];
% double[] RangeY = new double[oneRead];
% 
% for (int i = 0; i < oneRead; i++)
%     X[i] = ReaderBinary.ReadDouble();
% 
% for (int i = 0; i < oneRead; i++)
%     Y[i] = ReaderBinary.ReadDouble();
% 
% for (int i = 0; i < oneRead; i++)
%     Z[i] = ReaderBinary.ReadDouble();
% 
% for (int i = 0; i < oneRead; i++)
%     RangeX[i] = ReaderBinary.ReadDouble();
% 
% for (int i = 0; i < oneRead; i++)
%     RangeY[i] = ReaderBinary.ReadDouble();
function [data_X, data_Y, data_Z, data_RangeX, data_RangeY, data_flag] = read_bnt2D(filename) %bs000_YR_R10_0.bnt
    fid = fopen(filename);
    n_Rows = fread(fid,1,'uint16'); 
    n_Cols = fread(fid,1,'uint16');
%     disp([n_Rows n_Cols]);
    n_zMin = fread(fid,1,'double');
    n_len = fread(fid,1,'uint16');
    s_filename = fread(fid,n_len,'char');
    data_len = fread(fid,1,'uint32');
    data_len5 = data_len/5;
%     disp([n_Rows, n_Cols, n_Rows * n_Cols, data_len5]);
    data_X = fread(fid, data_len5,'double'); 
    data_X = reshape(data_X, [n_Cols n_Rows]);
    data_Y = fread(fid, data_len5,'double');
    data_Y = reshape(data_Y, [n_Cols n_Rows]);
    data_Z = fread(fid, data_len5,'double');
    data_Z = reshape(data_Z, [n_Cols n_Rows]);
    data_RangeX = fread(fid, data_len5,'double');
    data_RangeX = reshape(data_RangeX, [n_Cols n_Rows]);
    data_RangeY = fread(fid, data_len5,'double');
    data_RangeY = reshape(data_RangeY, [n_Cols n_Rows]);
    data_flag = (data_Z>n_zMin);
    fclose(fid);
    %plot3(data_X(data_flag),data_Y(data_flag),data_Z(data_flag),'.')
end




