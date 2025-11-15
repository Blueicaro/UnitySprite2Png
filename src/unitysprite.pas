unit unitysprite;
{ Unitysprite it's a class to read .meta files from unity that contains 2D sprites
 and export to png files

  Copyright (C) 2025 jorge turiel (aka blueicaro)

  This source is free software; you can redistribute it and/or modify it under
  the terms of the GNU General Public License as published by the Free
  Software Foundation; either version 2 of the License, or (at your option)
  any later version.

  This code is distributed in the hope that it will be useful, but WITHOUT ANY
  WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
  FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
  details.

  A copy of the GNU General Public License is available on the World Wide Web
  at <http://www.gnu.org/copyleft/gpl.html>. You can also obtain it by writing
  to the Free Software Foundation, Inc., 51 Franklin Street - Fifth Floor,
  Boston, MA 02110-1335, USA.
}

{
Package required BGRABitmapPack
See: https://bgrabitmap.github.io/doc/index.html
}

{$mode ObjFPC}{$H+}
{$modeSwitch advancedRecords}
interface

uses
  Classes, SysUtils, fgl, BGRABitmap, BGRABitmapTypes;

type
  TUnitySpriteException = TExceptionClass;

type

  { TRectUnitySprite }

  TRectUnitySprite = record
  private
    FHeight: longint;
    FSerializeVersion: integer;
    Fwitdth: longint;
    FX: longint;
    Fy: longint;
    procedure SetHeight(AValue: longint);
    procedure SetSerializeVersion(AValue: integer);
    procedure Setwidth(AValue: longint);
    procedure SetX(AValue: longint);
    procedure Sety(AValue: longint);
  public

    property SerializeVersion: integer read FSerializeVersion write SetSerializeVersion;
    property X: longint read FX write SetX;
    property y: longint read Fy write Sety;
    property Width: longint read Fwitdth write Setwidth;
    property Height: longint read FHeight write SetHeight;
    class operator =(L, R: TRectUnitySprite): boolean;
  end;



type

  { TUnitySpriteItem }

  TUnitySpriteItem = class
  private
    FRect: TRectUnitySprite;
    FSpriteName: string;
    FSpriteBmp: TBGRABitmap;
    procedure SetRect(AValue: TRectUnitySprite);
    procedure SetSpriteName(AValue: string);
  public
    constructor Create;
    destructor Destroy; override;
    property SpritePng: TBGRABitmap read FSpriteBmp;
    procedure ProcessLines(ALines: TStringList);
    property Rect: TRectUnitySprite read FRect write SetRect;
    property SpriteName: string read FSpriteName write SetSpriteName;
  end;

type
  TTUnitySpriteList = specialize TFPGObjectList<TUnitySpriteItem>;

type

  { TUnitySpriteImport }

  TUnitySpriteImport = class
  private
    FFileVersion: integer;
    FMetaFile: TFileName;
    FPngFile: TFileName;
    FSpriteList: TTUnitySpriteList;
    procedure SetSpriteList(AValue: TTUnitySpriteList);
    procedure ReadPngFile;
  public
    constructor Create;
    destructor Destroy; override;
    property MetaFile: TFileName read FMetaFile;
    property PngFile: TFileName read FPngFile;
    property SpriteList: TTUnitySpriteList read FSpriteList write SetSpriteList;
    procedure ReadUnityFile(AFileName: TFileName);
    procedure SaveAllSprites(ADir: TFileName);
  end;

implementation

uses StrUtils;
  { TRectUnitySprite }

procedure TRectUnitySprite.SetSerializeVersion(AValue: integer);
begin
  if FSerializeVersion = AValue then Exit;
  FSerializeVersion := AValue;
end;

procedure TRectUnitySprite.SetHeight(AValue: longint);
begin
  if FHeight = AValue then Exit;
  FHeight := AValue;
end;

procedure TRectUnitySprite.Setwidth(AValue: longint);
begin
  if Fwitdth = AValue then Exit;
  Fwitdth := AValue;
end;

procedure TRectUnitySprite.SetX(AValue: longint);
begin
  if FX = AValue then Exit;
  FX := AValue;
end;

procedure TRectUnitySprite.Sety(AValue: longint);
begin
  if Fy = AValue then Exit;
  Fy := AValue;
end;


class operator TRectUnitySprite.=(L, R: TRectUnitySprite): boolean;
begin
  Result := False;
  { #note : Raise a exception? }
  if L.FSerializeVersion <> R.FSerializeVersion then
    Exit;

  Result := (L.FHeight = R.FHeight) and (L.Fwitdth = L.Fwitdth) and
    (L.FX = R.FX) and (L.Fy = R.Fy) and (L.Width = R.Width);

end;

{ TUnitySpriteItem }

procedure TUnitySpriteItem.SetRect(AValue: TRectUnitySprite);
begin
  if FRect = AValue then Exit;
  FRect := AValue;
end;

procedure TUnitySpriteItem.SetSpriteName(AValue: string);
begin
  if FSpriteName = AValue then Exit;
  FSpriteName := AValue;
end;

constructor TUnitySpriteItem.Create;
begin
  FSpriteBmp := TBGRABitmap.Create;
end;

destructor TUnitySpriteItem.Destroy;
begin
  FreeAndNil(FSpriteBmp);
end;

procedure TUnitySpriteItem.ProcessLines(ALines: TStringList);
var
  I: integer;
  stValue: string;
begin
  I := 0;
  while I < ALines.Count do
  begin
    if CompareText('Name', (ExtractWord(1, ALines[I], [':']))) = 0 then
    begin
      SpriteName := Trim(ExtractWord(2, ALines[I], [':']));
    end;
    if (CompareText('rect', (ExtractWord(1, ALines[I], [':']))) = 0) then
    begin
      I := I + 1;
      while I < ALines.Count do
      begin
        stValue := Trim(ExtractWord(2, ALines[I], [':']));

        if CompareText('serializedVersion', (ExtractWord(1, ALines[I], [':']))) = 0 then
        begin
          FRect.SerializeVersion := StrToInt(stValue);
        end;
        if CompareText('x', (ExtractWord(1, ALines[I], [':']))) = 0 then
        begin
          FRect.X := StrToInt(stValue);
        end;
        if CompareText('y', (ExtractWord(1, ALines[I], [':']))) = 0 then
        begin
          FRect.Y := StrToInt(stValue);
        end;
        if CompareText('Width', (ExtractWord(1, ALines[I], [':']))) = 0 then
        begin
          FRect.Width := StrToInt(stValue);
        end;
        if CompareText('Height', (ExtractWord(1, ALines[I], [':']))) = 0 then
        begin
          FRect.Height := StrToInt(stValue);
        end;
        I := I + 1;
      end;

    end;
    I := I + 1;
  end;
end;

{ TUnitySpriteImport }


procedure TUnitySpriteImport.SetSpriteList(AValue: TTUnitySpriteList);
begin
  if FSpriteList = AValue then Exit;
  FSpriteList := AValue;
end;

  {
 After read .meta file, read png file to extract sprites and
 to sprites items
}
procedure TUnitySpriteImport.ReadPngFile;
var
  PngImage, SpriteImg: TBGRABitmap;
  I: integer;
  R: TRectUnitySprite;
  SrcRecT: TRect;
begin
  //Be sure we have something
  if FSpriteList.Count = 0 then
  begin
    exit;
  end;
  try
    PngImage := TBGRABitmap.Create(FPngFile);
    PngImage.SaveToFile('PngFile.png');
    for I := 0 to FSpriteList.Count - 1 do
    begin
      R := FSpriteList.Items[I].FRect;
      //origin of Y is on bottom, not on top as bitmap
      SrcRecT.Top := (PngImage.Height - R.y) - R.Height;
      SrcRecT.Left := R.X;
      SrcRecT.Width := R.Width;
      SrcRecT.Height := R.Height;
      SpriteImg := TBGRABitmap.Create(R.Width, R.Height);
      SpriteImg.PutImagePart(0, 0, PngImage, SrcRecT, dmSet);
      FSpriteList[I].FSpriteBmp.Assign(SpriteImg);
      FreeAndNil(SpriteImg);
    end;

  finally
    FreeAndNil(PngImage);
  end;

end;



constructor TUnitySpriteImport.Create;
begin
  FFileVersion := 2;
  FSpriteList := TTUnitySpriteList.Create();
end;

destructor TUnitySpriteImport.Destroy;
begin
  FreeAndNil(FSpriteList);
  inherited Destroy;
end;

procedure TUnitySpriteImport.ReadUnityFile(AFileName: TFileName);
var
  lsFichero: TStringList;  //File to read
  lsSpritesNames, lsSpriteDefinition: TStringList; //List os sprites in the read file
  I, StartNamesDefinition, IndexOfSprite: integer;
  PngFileName: string;
  Sprite: TUnitySpriteItem;

  function TestFileVersion: boolean;
  var
    stCadena: string;
  begin
    Result := False;
    if (lsFichero.Count > 0) then
    begin
      stCadena := Trim(lsFichero[0]);
      if CompareText('fileFormatVersion: ' + IntToStr(FFileVersion), stCadena) = 0 then
        Result := True;
    end;
  end;

  function FindSpriteDefinition: integer;
  var
    cadena: string;
    P: integer;
  begin
    Result := -1;
    P := 0;
    while P < lsFichero.Count do
    begin
      cadena := Trim(lsFichero[P]);
      //Be sure that can read next two lines
      if (CompareText('spriteSheet:', cadena) = 0) and (P + 2 < lsFichero.Count) then
      begin
        P := P + 1;
        Cadena := Trim(lsFichero[P]);
        if CompareText('serializedVersion:' + IntToStr(FFileVersion), Cadena) = 0 then
        begin
          P := P + 1;
          Cadena := trim(lsFichero[P]);
          if CompareText('sprites:', cadena) = 0 then
          begin
            Result := P;
            Exit;
          end;
        end;
      end;
      P := P + 1;
    end;

  end;

  function FindfileIDToRecycleName: integer;
  var
    Id: integer;
    idCadena: string;
  begin
    Result := -1;
    for Id := 0 to lsFichero.Count do
    begin
      idCadena := trim(lsFichero[id]);
      if CompareText('fileIDToRecycleName:', idCadena) = 0 then
      begin
        Result := id;
        Break;
      end;
    end;
  end;

  procedure FillNames;
  var
    index: integer;
    stLine, stNumber, stName: string;
    Dummy: int64;
  begin
    //lsSpritesNames.Clear;
    index := StartNamesDefinition;
    while index < lsFichero.Count do
    begin
      index := index + 1;
      stLine := Trim(lsFichero[index]);
      stNumber := ExtractWord(1, stLine, [':']);
      if TryStrToInt64(stNumber, Dummy) = True then
      begin
        stName := Trim(ExtractWord(2, stLine, [':']));
        lsSpritesNames.Add(stName);
      end
      else
      begin
        Break;
      end;
    end;
  end;

  function GetPngFileName: string;
  var
    PngFile, DirPng: TFileName;
  begin
    Result := '';
    PngFile := ExtractFileName(AFileName);
    DirPng := ExtractFileDir(AFileName);
    PngFile := Copy(PngFile, 0, Length(PngFile) - 5);
    PngFile := DirPng + PathDelim + PngFile;
    if FileExists(PngFile) then
    begin
      Result := PngFile;
    end;
  end;

begin
  FMetaFile := AFileName;
  FSpriteList.Clear;
  lsFichero := TStringList.Create;
  lsSpritesNames := TStringList.Create;
  lsSpriteDefinition := TStringList.Create;
  try
    try
      lsFichero.LoadFromFile(FMetaFile);
      if not TestFileVersion then
      begin
        raise  TUnitySpriteException.Create('File version incorrect. Must be version ' +
          IntToStr(FFileVersion));
      end;

      FPngFile := GetPngFileName;
      if FPngFile = EmptyStr then
      begin
        raise  TUnitySpriteException.Create('Can not find PNG file');
      end;
      StartNamesDefinition := FindfileIDToRecycleName;
      if StartNamesDefinition < 0 then
      begin
        raise  TUnitySpriteException.Create('Can not find Sprite names');
      end;
      FillNames;
      //Trim all items to avoid problems before search sprites
      for I := 0 to lsFichero.Count - 1 do
      begin
        lsFichero[I] := trim(lsFichero[I]);
      end;

      for I := 0 to lsSpritesNames.Count - 1 do
      begin
        IndexOfSprite := lsFichero.IndexOf('name: ' + lsSpritesNames[I]);
        if IndexOfSprite > -1 then
        begin
          lsSpriteDefinition.Clear;
          while IndexOfSprite < lsFichero.Count do
          begin
            if StartsStr('-', lsFichero[IndexOfSprite]) = True then
            begin
              Sprite := TUnitySpriteItem.Create;
              Sprite.ProcessLines(lsSpriteDefinition);
              FSpriteList.Add(Sprite);
              Break;
            end
            else
            begin
              lsSpriteDefinition.Add(lsFichero[IndexOfSprite]);
            end;
            IndexOfSprite := IndexOfSprite + 1;
          end;
        end;
      end;
    except
      on E: Exception do
        raise TUnitySpriteException.Create(E.Message);
    end;
    //Process list of sprites
    ReadPngFile;
  finally
    FreeAndNil(lsSpriteDefinition);
    FreeAndNil(lsSpritesNames);
    FreeAndNil(lsFichero);
  end;
end;

procedure TUnitySpriteImport.SaveAllSprites(ADir: TFileName);
var
  Png: string;
  I: integer;
begin
  for I := 0 to FSpriteList.Count - 1 do
  begin
    Png := FSpriteList[I].SpriteName + '.png';
    Png := ADir + PathDelim + Png;
    FSpriteList[I].FSpriteBmp.SaveToFile(Png);
  end;
end;

end.
