%%%%create stimulus list
Stimuli = {
    'F_Fall', 1, 'Female', 'Fall', 001;
    'F_Fall', 2, 'Female', 'Fall', 002;
    'F_Fall', 3, 'Female', 'Fall', 003;
    'F_Fall', 4, 'Female', 'Fall', 004;
    'F_Fall', 5, 'Female', 'Fall', 005;
    %%separate
    'F_Flat', 1, 'Female', 'Flat', 006;
    'F_Flat', 2, 'Female', 'Flat', 007;
    'F_Flat', 3, 'Female', 'Flat', 008;
    'F_Flat', 4, 'Female', 'Flat', 009;
    'F_Flat', 5, 'Female', 'Flat', 010;
    %%separate
    'M_Fall', 1, 'Male', 'Fall', 011;
    'M_Fall', 2, 'Male', 'Fall', 012;
    'M_Fall', 3, 'Male', 'Fall', 013;
    'M_Fall', 4, 'Male', 'Fall', 014;
    'M_Fall', 5, 'Male', 'Fall', 015;
    %%separate
    'M_Flat', 1, 'Male', 'Flat', 016;
    'M_Flat', 2, 'Male', 'Flat', 017;
    'M_Flat', 3, 'Male', 'Flat', 018;
    'M_Flat', 4, 'Male', 'Flat', 019;
    'M_Flat', 5, 'Male', 'Flat', 020};
%list all possible conditions:
%first row is condition1, second row is condition2 etc...
Conditions = {'F_Fall','F_Flat';
              'F_Flat','F_Fall';
              'M_Fall','M_Flat';
              'M_Flat','M_Fall'};
          
VoiceToneMaster.Stimuli = stimuli;
VoiceToneMaster.Conditions = Conditions;
%%%Then save the VoiceToneMaster into a .m file