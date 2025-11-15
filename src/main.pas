unit main;
{ This program read .meta files from unity that contains 2D sprites
  and export to png files.

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


{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, EditBtn, StdCtrls,
  Buttons, ExtCtrls;

type

  { TMainFrm }

  TMainFrm = class(TForm)
    btnGo: TBitBtn;
    DirectoryEdit1: TDirectoryEdit;
    FileNameEdit1: TFileNameEdit;
    ImageList1: TImageList;
    Label1: TLabel;
    Label2: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    procedure btnGoClick(Sender: TObject);
    procedure DirectoryEdit1Change(Sender: TObject);
    procedure FileNameEdit1Change(Sender: TObject);
  private
    procedure Validate;
  public

  end;

var
  MainFrm: TMainFrm;

implementation

uses unitysprite;

  {$R *.lfm}

  { TMainFrm }

procedure TMainFrm.btnGoClick(Sender: TObject);
var
  Sprites: TUnitySpriteImport;
begin
  Sprites := TUnitySpriteImport.Create;
  Try
    Sprites.ReadUnityFile(FileNameEdit1.Text);
    Sprites.SaveAllSprites(DirectoryEdit1.Text);
    ShowMessage(Format ('Processed %d sprites.',[Sprites.SpriteList.Count]));
  finally
    FreeAndNil(Sprites);
  end;
end;

procedure TMainFrm.DirectoryEdit1Change(Sender: TObject);
begin
  DirectoryEdit1.Hint:=DirectoryEdit1.Text;
  Validate;
end;

procedure TMainFrm.FileNameEdit1Change(Sender: TObject);
begin
  FileNameEdit1.Hint:=FileNameEdit1.Text;
  Validate;
end;

procedure TMainFrm.Validate;
begin
  btnGo.Enabled := (FileNameEdit1.Text <> EmptyStr) and
    (DirectoryEdit1.Text <> EmptyStr) and (FileExists(FileNameEdit1.Text));
end;

end.
