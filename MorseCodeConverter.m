classdef MorseCodeConverter < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                   matlab.ui.Figure
        Version10Button            matlab.ui.control.Button
        InstructionsStep1LoadinatextfilecontainingmorsecodeLabel  matlab.ui.control.Label
        MorseCodeConverterLabel_2  matlab.ui.control.Label
        SaveAudioButton            matlab.ui.control.Button
        ConvertedTextArea          matlab.ui.control.TextArea
        ConvertedTextAreaLabel     matlab.ui.control.Label
        DecodeButton               matlab.ui.control.Button
        MorseCodeConverterLabel    matlab.ui.control.Label
        ResetButton                matlab.ui.control.Button
        SaveTextButton             matlab.ui.control.Button
        PlayAudioButton            matlab.ui.control.Button
        LoadButton                 matlab.ui.control.Button
        MorseCodeTextArea          matlab.ui.control.TextArea
        MorseCodeTextAreaLabel     matlab.ui.control.Label
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: LoadButton
        function LoadButtonPushed(app, event)
        % setting up while loop to help this app recogize if user has selected a file or not after initiating the load button
        load = 0;
        while load < 20      
            [filename,path] = uigetfile('*.txt'); % opens devices file explorer to give you option to save the audio file
            % actions that take place if user has clicked the cancel button on their devices file explorer %
            if filename == 0 % setting up if statement to see if no text file was selected by the user       
                app.LoadButton.Enable = 'on';
                app.ResetButton.Visible = 'off'; 
                app.DecodeButton.Visible = 'off'; 
                % displays popup window to tell user they have not selected a text file to open
                answer = questdlg('Please select a text file', ...
                'Help', ...
                'ok','ok');
                switch answer  
                case 'ok'      
                end
                figure(app.UIFigure) % brings the app window back into focus  
                break;
            end
        
            % actions that take place if the user has selected to load in a text file % 
            temp=fileread(filename); % reads the data that is in the user selected text file
            figure(app.UIFigure); % brings the app window back into focus
            app.MorseCodeTextArea.Value=temp; % takes the morse code in the selected text file and displays it into the 'MorseCodeTextArea' textbox    
            app.ResetButton.Visible = 'on'; 
            app.DecodeButton.Visible = 'on'; 
            app.LoadButton.Enable = 'off';
            break;            
        end  
        end

        % Button pushed function: ResetButton
        function ResetButtonPushed(app, event)
        app.MorseCodeTextArea.Value = ''; 
        app.ConvertedTextArea.Value = '';
        app.ResetButton.Visible = 'off'; 
        app.SaveTextButton.Visible = 'off'; 
        app.DecodeButton.Visible = 'off'; 
        app.PlayAudioButton.Visible = 'off';
        app.SaveAudioButton.Visible = 'off';
        app.DecodeButton.Enable = 'on';
        app.LoadButton.Enable = 'on';
        end

        % Value changed function: MorseCodeTextArea
        function MorseCodeTextAreaValueChanged(app, event)
    
        end

        % Button pushed function: SaveTextButton
        function SaveTextButtonPushed(app, event)
        % converts characters in 'ConvertedTextArea' text box into a string and saves it into the variable 'value' %  
        value = app.ConvertedTextArea.Value;     
       
        % setting up while loop to help the app recognize if user has selected to save their text file or not after initiating the save button % 
        save = 0;
        while save < 20  
            [filename,path] = uiputfile('*.txt'); % opens devices file explorer to give you option to save a text file 
            % actions that take place if user has clicked the cancel button on their devices file explorer %
            if filename == 0 % setting up if statement to see if no file was saved            
                % displays popup window to tell user they have not saved their text file %
                answer = questdlg('You have not saved your text file', ...
                'Help', ...
                'Proceed','Proceed');
                switch answer
                case 'ok'
                end    
                figure(app.UIFigure) % brings the app window back into focus  
                break;
            end
            % actions that take place if the user has selected to save their converted morse text into a text file % 
            File = fullfile(path,filename); % tells app where the text file should be saved
            writecell(value, File); % writes what the variable 'value' contains into a text file
            % displays popup window to tell user they have saved their text file %
            answer = questdlg('You have saved your text file', ...
            'Help', ...
            'Proceed','Proceed');
            switch answer
            case 'ok'
            end
            figure(app.UIFigure) % brings the app window back into focus 
            break;          
        end
        end

        % Button pushed function: DecodeButton
        function DecodeButtonPushed(app, event)
        app.SaveTextButton.Visible = 'on'; 
        app.PlayAudioButton.Visible = 'on';
        app.DecodeButton.Enable = 'off';
        app.SaveAudioButton.Visible = 'on';
       
        % morse code and english conversion database %
        morse = struct;
        morse.a = '.-';
        morse.b = '-...';
        morse.c = '-.-.';
        morse.d = '-..';
        morse.e = '.';
        morse.f = '..-.';
        morse.g = '--.';
        morse.h = '....';
        morse.i = '..';
        morse.j = '.---';
        morse.k = '-.-';
        morse.l = '.-..';
        morse.m = '--';
        morse.n = '-.';
        morse.o = '---';
        morse.p = '.--.';
        morse.q = '--.-';
        morse.r = '.-.';
        morse.s = '...';
        morse.t = '-';
        morse.u = '..-';
        morse.v = '...-';
        morse.w = '.--';
        morse.x = '-..-';
        morse.y = '-.--';
        morse.z = '--..';
        morse.n1 = '.----';
        morse.n2 = '..---';
        morse.n3 = '...--';
        morse.n4= '....-';
        morse.n5 = '.....';
        morse.n6 = '-....';
        morse.n7 = '--...';
        morse.n8 = '---..';
        morse.n9 = '----.';
        morse.n0 = '-----';
        morse.sc = '.-,''';
        morse.scv = {['.-.-.-'],['-.-.-.'],['--..--'],['-.-.-.-']};
               
        % converts the morse code in 'ConvertedTextArea' textbox into characters and saves it into the variable 'value' %  
        value = char(app.MorseCodeTextArea.Value);
        
        % morse code to english translation code %
        code = value; % initializing the variable code to equal the variable value 
        deco = [];
        code = [code ' ']; % helps to separate the words by adding empty space
        lcode = []; % adds each character to this variable until there is an empty space     
        for j=1:length(code) % checks and stores length of text and loops for every character in the text
            if(strcmp(code(j),' ')||strcmp(code(j),'/')) % checks for an empty space or '/' in the inputted morse code
                % conversion for letters to characters %
                for i=double('a'):double('z') % runs loop to check for all alphabets
                    letter = getfield(morse,char(i)); % gets the morse code of each letter from the conversion database 
                        if strcmp(lcode,letter) % compares inputted morse code to morse code from conversion database
                            deco = [deco char(i)]; % if the comparsion turns out to be same it stores the converted morse code letter to the vairable 'deco' 
                        end
                end
                % conversion for numbers to string %        
                for i=0:9 % runs loop to check for all numbers
                    numb = getfield(morse,['n',num2str(i)]); % gets the value needed from the conversion database
                        if strcmp(lcode,numb) % compares inputted morse code to morse code from conversion database
                            deco = [deco,num2str(i)]; % if the comparison turns out to be same it stores the converted morse code value to the variable 'deco'
                        end
                end
                % conversion for special characters to string % 
                for i=1:4 % runs loop to check for all special characters
                    scv=char(morse.scv(i));
                        if strcmp(lcode,scv) % compares inputted morse code to morse code from conversion database
                            deco = [deco, morse.sc(i)]; % if the comparison turns out to be same it stores the converted morse code value to the variable 'deco'
                        end
                end    
                lcode = []; % empties the variable 'lcode' after checking for each individual letter
            else
                lcode = [lcode code(j)];
            end
            % adds a single space every time a '/' is detected %
            if strcmp(code(j),'/')
                deco = [deco ' '];     
            end    
         end
                 
         % displays the converted morse code into the 'ConvertedTextArea' textbox %  
         app.ConvertedTextArea.Value = char(deco);
        end

        % Value changed function: ConvertedTextArea
        function ConvertedTextAreaValueChanged(app, event)

        end

        % Button pushed function: PlayAudioButton
        function PlayAudioButtonPushed(app, event)
        % converts characters in 'ConvertedTextArea' text box into a string and saves it into the variable 'value' % 
        value = string(app.ConvertedTextArea.Value);
        
        % takes the string and converts it into audio that can be heard by the user    
        NET.addAssembly('System.Speech'); % loading the private assembly 'System.Speech' into MATLAB        
        mySpeaker = System.Speech.Synthesis.SpeechSynthesizer; % initializing the 'speech synthesizer' class
        mySpeaker.Volume = 100;
        myText = value; % sets the variable 'myText' to what text should be spoken by the 'speech synthesizer' 
        Speak(mySpeaker, myText) % initiates the text-to-speech 
        end

        % Button pushed function: SaveAudioButton
        function SaveAudioButtonPushed(app, event)
        % converts characters in 'ConvertedTextArea' into a string and saves it into the variable 'value' %
        value = string(app.ConvertedTextArea.Value);
        
        % takes the string from the variable 'value' and converts it into audio that can be saved  
        NET.addAssembly('System.Speech');
        synth = System.Speech.Synthesis.SpeechSynthesizer;    
        % opens devices file explorer to give you option to save the audio file %
        synth.SetOutputToWaveFile(uiputfile('*.wav'));  
        myText = value;
        Speak(synth, myText);
        synth.SetOutputToNull;
        % displays pop up window to tell user they have saved their audio file %
        answer = questdlg('You have saved your audio file', ...
        'Help', ...
        'Proceed','Proceed');
        switch answer
        case 'ok'
        end
        
        % brings the app back into focus %
        figure(app.UIFigure)  
        end

        % Button pushed function: Version10Button
        function Version10ButtonPushed(app, event)
        % displays pop up window to give info about the app %
        answer = questdlg({'Authors: Thanushan Ambalavanan';'';'Version 1.0 (Feb 13, 2022)'}, ...
        'Morse Code Converter', ...
        'ok','ok');
        switch answer
        case 'ok'
        end    
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Color = [0.102 0.102 0.102];
            app.UIFigure.Position = [100 100 646 464];
            app.UIFigure.Name = 'MATLAB App';

            % Create MorseCodeTextAreaLabel
            app.MorseCodeTextAreaLabel = uilabel(app.UIFigure);
            app.MorseCodeTextAreaLabel.FontName = 'Segoe UI Light';
            app.MorseCodeTextAreaLabel.FontSize = 13;
            app.MorseCodeTextAreaLabel.FontWeight = 'bold';
            app.MorseCodeTextAreaLabel.FontColor = [1 1 1];
            app.MorseCodeTextAreaLabel.Position = [241 334 72 22];
            app.MorseCodeTextAreaLabel.Text = 'Morse Code';

            % Create MorseCodeTextArea
            app.MorseCodeTextArea = uitextarea(app.UIFigure);
            app.MorseCodeTextArea.ValueChangedFcn = createCallbackFcn(app, @MorseCodeTextAreaValueChanged, true);
            app.MorseCodeTextArea.Editable = 'off';
            app.MorseCodeTextArea.FontName = 'Segoe UI';
            app.MorseCodeTextArea.Position = [241 265 291 61];

            % Create LoadButton
            app.LoadButton = uibutton(app.UIFigure, 'push');
            app.LoadButton.ButtonPushedFcn = createCallbackFcn(app, @LoadButtonPushed, true);
            app.LoadButton.HorizontalAlignment = 'left';
            app.LoadButton.BackgroundColor = [1 1 1];
            app.LoadButton.FontName = 'Segoe UI Light';
            app.LoadButton.FontSize = 13;
            app.LoadButton.FontWeight = 'bold';
            app.LoadButton.FontColor = [0.102 0.102 0.102];
            app.LoadButton.Position = [44 342 70 30];
            app.LoadButton.Text = 'Load';

            % Create PlayAudioButton
            app.PlayAudioButton = uibutton(app.UIFigure, 'push');
            app.PlayAudioButton.ButtonPushedFcn = createCallbackFcn(app, @PlayAudioButtonPushed, true);
            app.PlayAudioButton.HorizontalAlignment = 'left';
            app.PlayAudioButton.BackgroundColor = [1 1 1];
            app.PlayAudioButton.FontName = 'Segoe UI Light';
            app.PlayAudioButton.FontWeight = 'bold';
            app.PlayAudioButton.FontColor = [0.102 0.102 0.102];
            app.PlayAudioButton.Visible = 'off';
            app.PlayAudioButton.Position = [44 187 70 30];
            app.PlayAudioButton.Text = 'Play Audio';

            % Create SaveTextButton
            app.SaveTextButton = uibutton(app.UIFigure, 'push');
            app.SaveTextButton.ButtonPushedFcn = createCallbackFcn(app, @SaveTextButtonPushed, true);
            app.SaveTextButton.HorizontalAlignment = 'left';
            app.SaveTextButton.BackgroundColor = [1 1 1];
            app.SaveTextButton.FontName = 'Segoe UI Light';
            app.SaveTextButton.FontWeight = 'bold';
            app.SaveTextButton.FontColor = [0.102 0.102 0.102];
            app.SaveTextButton.Visible = 'off';
            app.SaveTextButton.Position = [44 84 72 29];
            app.SaveTextButton.Text = 'Save Text';

            % Create ResetButton
            app.ResetButton = uibutton(app.UIFigure, 'push');
            app.ResetButton.ButtonPushedFcn = createCallbackFcn(app, @ResetButtonPushed, true);
            app.ResetButton.HorizontalAlignment = 'left';
            app.ResetButton.BackgroundColor = [1 1 1];
            app.ResetButton.FontName = 'Segoe UI Light';
            app.ResetButton.FontWeight = 'bold';
            app.ResetButton.FontColor = [0.102 0.102 0.102];
            app.ResetButton.Visible = 'off';
            app.ResetButton.Position = [44 236 70 30];
            app.ResetButton.Text = 'Reset';

            % Create MorseCodeConverterLabel
            app.MorseCodeConverterLabel = uilabel(app.UIFigure);
            app.MorseCodeConverterLabel.FontName = 'Candara Light';
            app.MorseCodeConverterLabel.FontSize = 15;
            app.MorseCodeConverterLabel.Position = [509 388 147 22];
            app.MorseCodeConverterLabel.Text = 'Morse Code Converter';

            % Create DecodeButton
            app.DecodeButton = uibutton(app.UIFigure, 'push');
            app.DecodeButton.ButtonPushedFcn = createCallbackFcn(app, @DecodeButtonPushed, true);
            app.DecodeButton.HorizontalAlignment = 'left';
            app.DecodeButton.BackgroundColor = [1 1 1];
            app.DecodeButton.FontName = 'Segoe UI Light';
            app.DecodeButton.FontWeight = 'bold';
            app.DecodeButton.FontColor = [0.102 0.102 0.102];
            app.DecodeButton.Visible = 'off';
            app.DecodeButton.Position = [44 287 70 30];
            app.DecodeButton.Text = 'Decode';

            % Create ConvertedTextAreaLabel
            app.ConvertedTextAreaLabel = uilabel(app.UIFigure);
            app.ConvertedTextAreaLabel.FontName = 'Segoe UI Light';
            app.ConvertedTextAreaLabel.FontSize = 13;
            app.ConvertedTextAreaLabel.FontWeight = 'bold';
            app.ConvertedTextAreaLabel.FontColor = [1 1 1];
            app.ConvertedTextAreaLabel.Position = [241 224 128 24];
            app.ConvertedTextAreaLabel.Text = 'Converted';

            % Create ConvertedTextArea
            app.ConvertedTextArea = uitextarea(app.UIFigure);
            app.ConvertedTextArea.ValueChangedFcn = createCallbackFcn(app, @ConvertedTextAreaValueChanged, true);
            app.ConvertedTextArea.Editable = 'off';
            app.ConvertedTextArea.Position = [241 156 291 60];

            % Create SaveAudioButton
            app.SaveAudioButton = uibutton(app.UIFigure, 'push');
            app.SaveAudioButton.ButtonPushedFcn = createCallbackFcn(app, @SaveAudioButtonPushed, true);
            app.SaveAudioButton.HorizontalAlignment = 'left';
            app.SaveAudioButton.BackgroundColor = [1 1 1];
            app.SaveAudioButton.FontName = 'Segoe UI Light';
            app.SaveAudioButton.FontWeight = 'bold';
            app.SaveAudioButton.FontColor = [0.102 0.102 0.102];
            app.SaveAudioButton.Visible = 'off';
            app.SaveAudioButton.Position = [44 135 72 30];
            app.SaveAudioButton.Text = 'Save Audio';

            % Create MorseCodeConverterLabel_2
            app.MorseCodeConverterLabel_2 = uilabel(app.UIFigure);
            app.MorseCodeConverterLabel_2.FontName = 'Segoe UI Semibold';
            app.MorseCodeConverterLabel_2.FontSize = 20;
            app.MorseCodeConverterLabel_2.FontWeight = 'bold';
            app.MorseCodeConverterLabel_2.FontColor = [1 1 1];
            app.MorseCodeConverterLabel_2.Position = [42 408 212 31];
            app.MorseCodeConverterLabel_2.Text = 'Morse Code Converter';

            % Create InstructionsStep1LoadinatextfilecontainingmorsecodeLabel
            app.InstructionsStep1LoadinatextfilecontainingmorsecodeLabel = uilabel(app.UIFigure);
            app.InstructionsStep1LoadinatextfilecontainingmorsecodeLabel.FontName = 'Segoe UI';
            app.InstructionsStep1LoadinatextfilecontainingmorsecodeLabel.FontSize = 10;
            app.InstructionsStep1LoadinatextfilecontainingmorsecodeLabel.FontColor = [1 1 1];
            app.InstructionsStep1LoadinatextfilecontainingmorsecodeLabel.Position = [241 47 399 98];
            app.InstructionsStep1LoadinatextfilecontainingmorsecodeLabel.Text = {'Instructions'; 'Step 1: Click the button ''Load'' to load in a text file containing morse code'; 'Step 2: Click the button ''decode'''; ''; ''; ''};

            % Create Version10Button
            app.Version10Button = uibutton(app.UIFigure, 'push');
            app.Version10Button.ButtonPushedFcn = createCallbackFcn(app, @Version10ButtonPushed, true);
            app.Version10Button.BackgroundColor = [0.102 0.102 0.102];
            app.Version10Button.FontName = 'Segoe UI';
            app.Version10Button.FontSize = 10;
            app.Version10Button.FontWeight = 'bold';
            app.Version10Button.FontColor = [1 1 1];
            app.Version10Button.Position = [3 3 100 23];
            app.Version10Button.Text = 'Version 1.0';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = MorseCodeConverter

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end