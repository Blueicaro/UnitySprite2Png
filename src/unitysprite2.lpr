program unitysprite2;

uses
  SysUtils,
  Classes,
  unitysprite;

var
  NumerParams: longint;
  CurrentDir, InputFile, OutputDir: string;

  procedure Process;
  var
    Sprite: TUnitySpriteImport;
  begin
    try
      Sprite := TUnitySpriteImport.Create;
      try
        Sprite.ReadUnityFile(InputFile);
        Writeln(Format('Found %d sprites', [Sprite.SpriteList.Count]));
        Sprite.SaveAllSprites(OutputDir);
      except
        on E: Exception do
          WriteLn(E.Message);
      end;

    finally
      FreeAndNil(Sprite);
    end;
  end;

  procedure CheckParams;
  begin
    NumerParams := ParamCount;
    if NumerParams < 1 then
    begin
      Writeln('Need parameters');
      Writeln('First parameter: Filename');
      Writeln('Second parameter: OutPutDir (optional');
      Writeln('Usage: unitysprite2cge spritesheet_boss.png.meta ./output/');
      Halt;
    end;
  end;

begin
  CheckParams;
  CurrentDir := ParamStr(0);
  OutputDir := ExtractFileDir(CurrentDir);
  InputFile := ParamStr(1);
  if NumerParams = 2 then
  begin
    OutputDir := ParamStr(2);
  end;
  Writeln ('Unity Sprites to png');
  WriteLn('Input file: '+InputFile);
  WriteLn('Output dir: '+OutputDir);
  Writeln('Press any key to continue');
  Readln;
  Process;
end.
