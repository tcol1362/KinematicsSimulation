function serialObjIMU = SetupIMUSerial(IMUCOM)
%% =======================Serial IMU Communication=========================
% RoboHAZMAT: Senior Design Project
% Motion Control Team
% Gerardo Bledt
% December 15, 2014
%
% Ability to connect to the IMU sensor and read in data over Serial.

% Setup Serial Communication with IMU
disp(' ');
disp('Setup Serial Communication...');

% Check if COM port is available
if (~ismember(GetAvailableCOM,IMUCOM))
    error('%s is not available',IMUCOM);
end

% Create and open Serial communication
serialObjIMU = serial(IMUCOM,'BAUD',9600,'InputBufferSize',32);
fopen(serialObjIMU);
pause(2);

disp('Initializing IMU...');
% Clear received message in buffer
while (isempty(strfind(serialObjIMU.fscanf,'Initializing I2C devices...')))
end

% Test Connections
disp('IMU Connection Successful. Initializing DMP...');
while (isempty(strfind(serialObjIMU.fscanf,'Initializing DMP...')))
end

% Enable DMP
disp('DMP Connection Successful. Enabling DMP...');
while (isempty(strfind(serialObjIMU.fscanf,'Enabling DMP...')))
end
disp('DMP Enabled. Ready for use.');

% Clear current buffer
while (serialObjIMU.BytesAvailable > 0)
    fscanf(serialObjIMU);
end

disp('Calibrating IMU...');
calibrated = CalibrateIMU(serialObjIMU);

if (calibrated)
    disp('Ready to use!');
    disp(' ');
else
    delete(serialObjIMU); 
    SetupIMUSerial(IMUCOM);
end
