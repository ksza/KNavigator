program K_Navigator;
{$M 65000, 0, 65000}
uses crt, dos, UMain, UChDrive, UMkDir, UMnBar, UFView, UAsciiT, UPrompt,
     UInfo, USort, UCDM, UOsInfo, UChFAttr, UAbout, UMyStack, USearch,
     USearchF, UHelp, USubMnBr;
var LeftMainWin, RightMainWin: TMainForm;
    ChDriveWin: TChDriveWin;
    MkDirWin: TMkDir;
    MenuBarWin: TMenuBar;
    FileViewWin: TFileView;
    AsciiTableWin: TAsciiT;
    PromptWin: TPromptWin;
    InformationWin: TInformation;
    SortWin: TSort;
    CDMWin: TCDM;
    OsInfoWin: TOsInfoWin;
    ChFAttrWin: TChFAttr;
    AboutWin: TAbout;
    SearchWin: TSearch;
    SearchForFilesWin: TSearchForFiles;
    HelpWin: THelp;
    SubMenuBarWin: TSubMenuBar;
    c, ca, drv: char;
    b, b_Exit, LeftWinInfo, RightWinInfo: boolean;
    Exista, Exista2, Toate, NiciUnul, Toate2, NiciUnul2: boolean;
    Director, Director_Curent, SelectedMenuItm, Comm: string;
    Prompt_Value, Prompt_Value2, Prompt_Value3, SelectedItm: string;
    Prompt_Value4, Prompt_Value5: string;
    GNume, GExt, Grup: string; { nume si extensie grup }
    FMask, FName, TipCautare, DestinatieCautare: string;
    FisierCautat, DirectorulFisieruluiCautat: string;
    GCont: integer; { contor pt delimitarea GNume, GExt din Grup }
    FileTypes, SortType: Word;
    Butoane: vect;
    i_aux, j_aux: integer;
label Label_Iesire, Label_Vizualizare, Label_CreazaDirector, Label_SchimbaUS,
      Label_SchimbaUD, Label_Copiaza, {Label_Muta,} Label_Sterge,
      Label_Selecteaza_Grup,
      Label_Deselecteaza_Grup, Label_DG_Revenire,
      Label_Cauta, Label_Cauta_Revenire,
      Label_ExecutaOS, Label_ExecutaOS_Revenire,
      Label_Help, Label_Help_Revenire,
      Label_UnderConstruction, Label_UnderConstruction_Revenire;
procedure ExecCommand(Command: string);
  begin
    if Command <> '' then
      Command := '/C ' + Command;
    SwapVectors;
    Exec(GetEnv('COMSPEC'), Command);
    SwapVectors;
    if DosError <> 0 then
      Writeln('Could not execute COMMAND.COM');
  end;

procedure Refr1;
  begin
    case b of
      false: begin
               LeftMainWin.BuildCursor;
               LeftMainWin.ShowCurentDir(Cyan);
               LeftMainWin.ShowDrives1;
               if (LeftWinInfo = false) then begin
                 RightMainWin.ShowDrives1;
                 RightMainWin.ShowCurentDir(blue);
               end;
             end;
      true:  begin
               RightMainWin.BuildCursor;
               RightMainWin.ShowCurentDir(Cyan);
               RightMainWin.ShowDrives1;
               if (RightWinInfo = false) then begin
                 LeftMainWin.ShowDrives1;
                 LeftMainWin.ShowCurentDir(blue);
               end;
             end;
    end;
  end;

procedure Refr2;
  begin
    if (LeftWinInfo = true) then begin
      RightMainWin.SetFocus;
      InformationWin.Refresh;
      LeftMainWin.Refresh;
    end
    else
      if (RightWinInfo = true) then begin;
        LeftMainWin.SetFocus;
        InformationWin.Refresh;
        RightMainWin.Refresh;
      end
      else begin
        LeftMainWin.Refresh;
        RightMainWin.Refresh;
      end;
  end;
begin
  clrscr;
  GetDir(0, Director_Curent);
  LeftMainWin.init(1, 1, 40, 22, Director_Curent);
  RightMainWin.init(41, 1, 40, 22, Director_Curent);
  RightMainWin.SetFocus; RightMainWin.ShowDrives1;
  SubMenuBarWin.BuildSubMenuBar;
  b:=false; b_Exit:=false; Grup:='';
  LeftWinInfo:=false; RightWinInfo:=false;
  LeftMainWin.BuildCursor; LeftMainWin.ShowDrives1;
  LeftMainWin.ShowCurentDir(cyan);
  repeat
    c:=readkey;
    case c of
      #68: begin
             {case b of
               false: LeftMainWin.DestructCursor;
               true:  RightMainWin.DestructCursor;
             end;}
             MenuBarWin.init(Director_Curent + '\Res\MItems');
             SelectedMenuItm:=MenuBarWin.SelectItems;
             MenuBarWin.done;

             Refr2; Refr1;

       if SelectedMenuItm <> '' then begin
             if SelectedMenuItm = 'Iesire (X)' then
               goto Label_Iesire;

             if SelectedMenuItm = 'Vizualizare...' then
               goto Label_Vizualizare;

             if SelectedMenuItm = 'Creaza Director (M)' then
               goto Label_CreazaDirector;

             if SelectedMenuItm = 'Schimba unitatea (d)' then begin
               case b of
                 false: if (RightWinInfo = false) then begin
                          ChDriveWin.init(17, 3, LeftMainWin.Drives);
                          ca:=ChDriveWin.SelectDrive;
                          if ca <> '0' then begin
                            for drv:='A' to 'Z' do
                              if LeftMainWin.Drives[drv].selectat = true then
                                 LeftMainWin.Drives[drv].selectat:=false;
                            LeftMainWin.Drives[ca].selectat:=true;
                            LeftMainWin.Curent_Drive:=ca;
                            LeftMainWin.Refresh;
                            LeftMainWin.ShowDrives1;
                            {LeftMainWin.ClearMainWin; LeftMainWin.draw;}
                            LeftMainWin.OnClickEvent(ca + ':\');

                            if LeftWinInfo = true then begin
                              RightMainWin.SetFocus;
                              with LeftMainWin do
                                InformationWin.init(Cale, Curent_Drive, sant1, sant2);
                              LeftMainWin.SetFocus;
                            end;
                          end
                          else begin
                            LeftMainWin.Refresh;
                            LeftMainWin.ShowCurentDir(Cyan);
                            LeftMainWin.BuildCursor;
                          end;
                        end;
                 true: if (LeftWinInfo = false) then begin
                         ChDriveWin.init(57, 3, RightMainWin.Drives);
                         ca:=ChDriveWin.SelectDrive;
                         if ca <> '0' then begin
                           for drv:='A' to 'Z' do
                             if RightMainWin.Drives[drv].selectat = true then
                               RightMainWin.Drives[drv].selectat:=false;
                           RightMainWin.Drives[ca].selectat:=true;
                           RightMainWin.Curent_Drive:=ca;
                           RightMainWin.Refresh;
                           RightMainWin.ShowDrives1;
                           {RightMainWin.ClearMainWin; RightMainWin.draw;}
                           RightMainWin.OnClickEvent(ca + ':\');

                           if RightWinInfo = true then begin
                             LeftMainWin.SetFocus;
                             with RightMainWin do
                               InformationWin.init(Cale, Curent_Drive, sant1, sant2);
                             RightMainWin.SetFocus;
                           end;
                         end
                         else begin
                           RightMainWin.Refresh;
                           RightMainWin.ShowCurentDir(Cyan);
                           RightMainWin.BuildCursor;
                         end;
                       end;
               end; { EndCase }
             end;

             if SelectedMenuItm = 'Schimba unitatea din stanga (f)' then
               goto Label_SchimbaUS;

             if SelectedMenuItm = 'Schimba unitatea din dreapta (h)' then
               goto Label_SchimbaUD;

             if SelectedMenuItm = 'Tabela ASCII' then begin
               AsciiTableWin.init(5, 2);
               AsciiTableWin.done;
               Refr2; Refr1;
             end;

             if SelectedMenuItm = 'Informatii' then begin
               case b of
                 false: begin
                         LeftWinInfo:=not LeftWinInfo;
                         if LeftWinInfo = true then begin
                           RightMainWin.SetFocus;
                           with LeftMainWin do
                             InformationWin.init(Cale, Curent_Drive, sant1, sant2);
                           LeftMainWin.SetFocus;
                         end
                         else begin
                           RightMainWin.Refresh;
                           LeftMainWin.SetFocus;
                         end;
                       end;
                 true: begin
                          RightWinInfo:=not RightWinInfo;
                          if RightWinInfo = true then begin
                            LeftMainWin.SetFocus;
                            with RightMainWin do
                              InformationWin.init(Cale, Curent_Drive, sant1, sant2);
                            RightMainWin.SetFocus;
                          end
                          else begin
                            LeftMainWin.Refresh;
                            RightMainWin.SetFocus;
                          end;
                        end;
               end;
               refr1;
             end;

             if SelectedMenuItm = 'Sorteaza dupa...' then begin
               case b of
                 false: begin
                          SortWin.init(2, 3);
                          SortType:=SortWin.Navigate;
                          if (SortType <> 0) then
                            LeftMainWin.Sortare:=SortType;
                          LeftMainWin.RefreshFTS(0);
                          LeftMainWin.ShowDrives1;
                        end;
                 true: begin
                         SortWin.init(42, 3);
                         SortType:=SortWin.Navigate;
                         if (SortType <> 0) then
                           RightMainWin.Sortare:=SortType;
                         RightMainWin.RefreshFTS(0);
                         RightMainWin.ShowDrives1;
                       end;
               end;
               refr1;
             end;

             {if SelectedMenuItm = 'Atribute fisier' then begin
               case b of
                 false: with LeftMainWin do begin
                          ChFAttrWin.init(2, 3, k^.real_name + '.' + k^.real_ext);
                          SetFileAttr(k^.real_name + '.' + k^.real_ext, ChFAttrWin.GetFileTypes);
                          LeftMainWin.Refresh;
                          LeftMainWin.ShowDrives1;
                        end;
                 true: with RightMainWin do begin
                         ChFAttrWin.init(42, 3, k^.real_name + '.' + k^.real_ext);
                         SetFileAttr(k^.real_name + '.' + k^.real_ext, ChFAttrWin.GetFileTypes);
                         RightMainWin.Refresh;
                         RightMainWin.ShowDrives1;
                       end;
               end;
               refr1;
             end;}

             {if SelectedMenuItm = 'Cautare unitati' then begin
               with LeftMainWin do begin
                 FindDrives(drives);
                 drives[curent_drive].selectat:=true;
                 ChDir(curent_drive);
                 if RightWinInfo = false then
                   DrawBorders;
               end;
               with RightMainWin do begin
                 FindDrives(drives);
                 drives[curent_drive].selectat:=true;
                 ChDir(curent_drive);
                 if LeftWinInfo = false then
                   DrawBorders;
               end;
             end;}

             if SelectedMenuItm = 'Despre (A)' then begin
               AboutWin.init(26, 3);
               AboutWin.Select;
               Refr2; Refr1;
             end;

             if SelectedMenuItm = 'Creaza fisier (N)' then begin
               MkDirWin.init(25, 5, 'Creaza fisier', 'Nume');
               Director:=MkDirWin.GetDir('');
               if Director <> '' then begin
                 ExecCommand('edit' + ' ' + director);
                 if (RightWinInfo = false) then
                   LeftMainWin.RefreshFTS(0)
                 else
                   with LeftMainWin do begin
                     DestructSortedContent(sant1, sant2);
                     BuildSortedContent(sant1, sant2, Sortare);
                   end;
                 if (LeftWinInfo = false) then
                   RightMainWin.RefreshFTS(0)
                 else
                   with RightMainWin do begin
                     DestructSortedContent(sant1, sant2);
                     BuildSortedContent(sant1, sant2, Sortare);
                   end;
               end;
               refr1;
             end;

             if SelectedMenuItm = 'Copiaza...' then
               goto Label_Copiaza;

             {if SelectedMenuItm = 'Muta' then
               goto Label_Muta;}

             if SelectedMenuItm = 'Sterge (D)' then
               goto Label_Sterge;

             if SelectedMenuItm = 'Selecteaza grup...' then
               goto Label_Selecteaza_Grup;

             if SelectedMenuItm = 'Deselecteaza grup...' then
               goto Label_Deselecteaza_Grup;

             if SelectedMenuItm = 'Cauta (F)...' then begin
               goto Label_Cauta;
               Label_Cauta_Revenire:
             end;

             if SelectedMenuItm = 'Executa comanda OS' then begin
               goto Label_ExecutaOS;
               Label_ExecutaOS_Revenire:
             end;

             if SelectedMenuItm = 'Ajutor (H)' then begin
               goto Label_Help;
               Label_Help_Revenire:
             end;

             if (SelectedMenuItm = 'Redenumeste...')or(SelectedMenuItm = 'Muta...')or
                (SelectedMenuItm = 'Executa comanda OS')or(SelectedMenuItm = 'Formatare discheta...')or
                (SelectedMenuItm = 'Eticheta de Volum...')or(SelectedMenuItm = 'Informatii Memorie')or
                (SelectedMenuItm = 'Informatii System')or(SelectedMenuItm = 'Inverseaza Ecrane')or
                (SelectedMenuItm = 'Cautare unitati')or(SelectedMenuItm = 'Atribute fisier') then begin
               goto Label_UnderConstruction;
               Label_UnderConstruction_Revenire:
             end;
{----------------------------------------------------------------------------}
       end;
           end;
      #9: begin
            if (LeftWinInfo = false)and(RightWinInfo = false) then begin
              b:=not b;
              case b of
                false: begin
                         RightMainWin.ShowCurentDir(blue);
                         RightMainWin.DestructCursor;
                         LeftMainWin.ShowCurentDir(cyan);
                         LeftMainWin.BuildCursor;
                         ChDir(LeftMainWin.Cale);
                       end;
                true: begin
                        LeftMainWin.ShowCurentDir(blue);
                        LeftMainWin.DestructCursor;

                        RightMainWin.ShowCurentDir(cyan);
                        RightMainWin.BuildCursor;
                        ChDir(RightMainWin.Cale);
                      end;
              end;
            end;
          end;
      #72: case b of
             false: LeftMainWin.MoveCursorUp;
             true: RightMainWin.MoveCursorUp;
           end;
      #80: case b of
             false: LeftMainWin.MoveCursorDown;
             true: RightMainWin.MoveCursorDown;
           end;
      #75: case b of
             false: LeftMainWin.MoveCursorLeft;
             true: RightMainWin.MoveCursorLeft;
           end;
      #77: case b of
             false: LeftMainWin.MoveCursorRight;
             true: RightMainWin.MoveCursorRight;
           end;
      #13: begin
             case b of
               false: with LeftMainWin do
                        if (k^.tip = 'F')and((k^.ext = 'exe')or(k^.ext = 'bat')or(k^.ext = 'com')) then begin
                          Comm:=k^.real_name + '.' + k^.real_ext;
                          LeftMainWin.done; RightMainWin.done;
                          SubMenuBarWin.DestructSubMenuBar;
                          ExecCommand(Comm);
                          TextBackground(black);
                          RightMainWin.Refresh; LeftMainWin.Refresh;
                          SubMenuBarWin.BuildSubMenuBar;


                          LeftMainWin.BuildCursor;
                          LeftMainWin.ShowCurentDir(Cyan);
                          LeftMainWin.ShowDrives1;
                          if (LeftWinInfo = false) then begin
                            RightMainWin.ShowDrives1;
                            RightMainWin.ShowCurentDir(blue);
                          end;
                        end
                        else
                          if (k^.tip = 'D') then OnClickEvent('');
               true: with RightMainWin do
                        if (k^.tip = 'F')and((k^.ext = 'exe')or(k^.ext = 'bat')) then begin
                          Comm:=k^.real_name + '.' + k^.real_ext;
                          LeftMainWin.done; RightMainWin.done;
                          SubMenuBarWin.DestructSubMenuBar;
                          ExecCommand(Comm);
                          TextBackGround(black);
                          LeftMainWin.Refresh; RightMainWin.Refresh;
                          SubMenuBarWin.BuildSubMenuBar;

                          RightMainWin.BuildCursor;
                          RightMainWin.ShowCurentDir(Cyan);
                          RightMainWin.ShowDrives1;
                          if (RightWinInfo = false) then begin
                            LeftMainWin.ShowDrives1;
                            LeftMainWin.ShowCurentDir(blue);
                          end;
                        end
                        else
                          if (k^.tip = 'D') then OnClickEvent('');
             end;

             if (LeftWinInfo = true) then begin
               RightMainWin.SetFocus;
               with LeftMainWin do
                 InformationWin.init(Cale, Curent_Drive, sant1, sant2);
               LeftMainWin.SetFocus;
             end
             else if (RightWinInfo = true) then begin
               LeftMainWin.SetFocus;
               with RightMainWin do
                 InformationWin.init(Cale, Curent_Drive, sant1, sant2);
               RightMainWin.SetFocus;
             end;
           end;
      #59: Label_SchimbaUS:
           if (RightWinInfo = false) then begin { F1 }
             ChDriveWin.init(17, 3, LeftMainWin.Drives);
             ca:=ChDriveWin.SelectDrive;
             if ca <> '0' then begin
               for drv:='A' to 'Z' do
                 if LeftMainWin.Drives[drv].selectat = true then
                   LeftMainWin.Drives[drv].selectat:=false;
               LeftMainWin.Drives[ca].selectat:=true;
               LeftMainWin.Curent_Drive:=ca;
               LeftMainWin.Refresh;
               LeftMainWin.ShowDrives1;
               {LeftMainWin.ClearMainWin; LeftMainWin.draw;}
               LeftMainWin.OnClickEvent(ca + ':\');

               if LeftWinInfo = true then begin
                 RightMainWin.SetFocus;
                 with LeftMainWin do
                   InformationWin.init(Cale, Curent_Drive, sant1, sant2);
                 LeftMainWin.SetFocus;
               end;
             end
             else begin
               LeftMainWin.Refresh;
               LeftMainWin.ShowCurentDir(Cyan);
               LeftMainWin.BuildCursor;
             end;

             if b = true then begin
               LeftMainWin.DestructCursor;
               LeftMainWin.ShowCurentDir(Blue);
               RightMainWin.SetFocus;
             end;
           end;
      #60: Label_SchimbaUD:
           if (LeftWinInfo = false) then begin { F2 }
             ChDriveWin.init(57, 3, RightMainWin.Drives);
             ca:=ChDriveWin.SelectDrive;
             if ca <> '0' then begin
               for drv:='A' to 'Z' do
                 if RightMainWin.Drives[drv].selectat = true then
                   RightMainWin.Drives[drv].selectat:=false;
               RightMainWin.Drives[ca].selectat:=true;
               RightMainWin.Curent_Drive:=ca;
               RightMainWin.Refresh;
               RightMainWin.ShowDrives1;
               {RightMainWin.ClearMainWin; RightMainWin.draw;}
               RightMainWin.OnClickEvent(ca + ':\');

               if RightWinInfo = true then begin
                 LeftMainWin.SetFocus;
                 with RightMainWin do
                   InformationWin.init(Cale, Curent_Drive, sant1, sant2);
                 RightMainWin.SetFocus;
               end;
             end
             else begin
               RightMainWin.Refresh;
               RightMainWin.ShowCurentDir(Cyan);
               RightMainWin.BuildCursor;
             end;

             if b = false then begin
               RightMainWin.DestructCursor;
               RightMainWin.ShowCurentDir(Blue);
               LeftMainWin.SetFocus;
             end;
           end;
      #65: Label_CreazaDirector:
           begin    { F7 }
             MkDirWin.init(25, 5, 'Creaza Director', 'Nume');
             Director:=MkDirWin.GetDir('');
             if Director <> '' then begin
               MkDir(Director);
               if (RightWinInfo = false) then
                 LeftMainWin.RefreshFTS(0)
               else
                 with LeftMainWin do begin
                   DestructSortedContent(sant1, sant2);
                   BuildSortedContent(sant1, sant2, Sortare);
                 end;
               if (LeftWinInfo = false) then
                 RightMainWin.RefreshFTS(0)
               else
                 with RightMainWin do begin
                   DestructSortedContent(sant1, sant2);
                   BuildSortedContent(sant1, sant2, Sortare);
                 end;
             end;
             Refr2;
             case b of
               false: ChDir(LeftMainWin.Cale);
               true: ChDir(RightMainWin.Cale);
             end;

             Refr1;
           end;
      #67: Label_Vizualizare:
           begin    { F9 }
             FileViewWin.init(28, 4, Director_Curent);
             FileTypes:=FileViewWin.GetFileTypes;

             if FileTypes <> 0 then begin
               if (RightWinInfo = false) then
                 LeftMainWin.RefreshFTS(FileTypes)
               else
                 with LeftMainWin do begin
                   FTS:=FileTypes; { FTS - din clasa LeftMainWin }
                   DestructSortedContent(sant1, sant2);
                   BuildSortedContent(sant1, sant2, Sortare);
                 end;

               if (LeftWinInfo = false) then
                 RightMainWin.RefreshFTS(FileTypes)
               else
                 with RightMainWin do begin
                   FTS:=FileTypes; { FTS - din clasa RightMainWin }
                   DestructSortedContent(sant1, sant2);
                   BuildSortedContent(sant1, sant2, Sortare);
                 end;
             end;

              Refr2; Refr1;
           end;
      #62: begin
           case b of   { F4 }
             false: with LeftMainWin do
                      if (k^.tip  = 'F') then begin
                        Comm:=k^.real_name + '.' + k^.real_ext;
                        LeftMainWin.done; RightMainWin.done;
                        SubMenuBarWin.DestructSubMenuBar;
                        ExecCommand('edit' + ' ' + Comm);
                        TextBackground(black);
                        RightMainWin.Refresh; LeftMainWin.Refresh;
                        SubMenuBarWin.BuildSubMenuBar;
                        LeftMainWin.BuildCursor;
                        LeftMainWin.ShowCurentDir(Cyan);
                        LeftMainWin.ShowDrives1;
                        if (LeftWinInfo = false) then begin
                          RightMainWin.ShowDrives1;
                          RightMainWin.ShowCurentDir(blue);
                        end;
                      end;
             true: with RightMainWin do
                     if (k^.tip = 'F') then begin
                       Comm:=k^.real_name + '.' + k^.real_ext;
                       LeftMainWin.done; RightMainWin.done;
                       SubMenuBarWin.DestructSubMenuBar;
                       ExecCommand('edit' + ' ' + Comm);
                       TextBackGround(black);
                       LeftMainWin.Refresh; RightMainWin.Refresh;
                       SubMenuBarWin.BuildSubMenuBar;
                       RightMainWin.BuildCursor;
                       RightMainWin.ShowCurentDir(Cyan);
                       RightMainWin.ShowDrives1;
                       if (RightWinInfo = false) then begin
                         LeftMainWin.ShowDrives1;
                         LeftMainWin.ShowCurentDir(blue);
                       end;
                     end;
           end;

             if (LeftWinInfo = true) then begin
               RightMainWin.SetFocus;
               InformationWin.Refresh;
             end
             else
             if (RightWinInfo = true) then begin;
               LeftMainWin.SetFocus;
               InformationWin.Refresh;
              end;

           end;
      #63: Label_Copiaza:
           if (LeftWinInfo = false)and(RightWinInfo = false) then  begin
  { F5 }
           if (RightMainWin.Cale) = (LeftMainWin.Cale) then begin
             Butoane[1]:='OK';
             PromptWin.init(23, 5, 'Directorul sursa este identic cu directorul destinatie !', 1, Butoane, Red, 'Eroare');
             Prompt_Value:=PromptWin.Select;
             PromptWin.done;

             LeftMainWin.Refresh; RightMainWin.Refresh;
             Refr1;
           end
           else
             case b of
               false: {if ((LeftMainWin.SelectedItmNr = 0)and(LeftMainWin.k^.real_name = '..')) then begin
                           Butoane[1]:='OK';
                           PromptWin.init(21, 5, 'Nici un fisier selectat !', 1, Butoane, Red, 'Eroare');
                           Prompt_Value:=PromptWin.Select;
                           PromptWin.done;

                           LeftMainWin.Refresh; RightMainWin.Refresh;
                           Refr1;
                      end
                      else} begin
                          if LeftMainWin.SelectedItmNr = 0 then
                            LeftMainWin.Select_FD;

                      Butoane[1]:='Da'; Butoane[2]:='Nu';
                      str(LeftMainWin.SelectedItmNr, SelectedItm);
                      PromptWin.init(21, 2, 'Doriti sa copiati cele ' + SelectedItm + ' fisiere selectate din ' +
                                     LeftMainWin.Cale + ' in ' + RightMainWin.Cale + ' ?', 2, Butoane, LightGray,
                                     'Interogare');
                      Prompt_Value3:=PromptWin.Select;
                      PromptWin.done;

                      if Prompt_Value3 = 'Da' then begin

                        CDMWin.init(12, 2, 'Copiere', LeftMainWin.Cale + '\',
                                    RightMainWin.Cale + '\', LeftMainWin.SelectedItmNr );
                        OsInfoWin.init(1, 12, 'Os Info');
                        Toate:=false; NiciUnul:=false; Prompt_Value:='';
                        with LeftMainWin do begin
                          k:=sant1^.link;
                          while (k <> sant2) do begin
                            if (k^.tip = 'D')and(k^.selected = true) then begin
                              if (length(Cale) > 3) then
                                CopyDirectory(Cale + '\' + k^.real_name, RightMainWin.Cale)
                              else
                                CopyDirectory(Cale + k^.real_name, RightMainWin.Cale);
                              k^.selected:=false;
                              dec(SelectedItmNr);
                              SelectedItmSize:=SelectedItmSize + k^.size;
                              ChDir(Cale);
                            end
                            else
                            if (k^.tip = 'F')and(k^.selected = true) then begin
                              Exista:=false;
                              CDMWin.ShowMessage(k^.real_name + '.' + k^.real_ext);
                              if (RightMainWin.FileExists(k^.real_name + '.' + k^.real_ext) = true) then begin
                                Exista:=true;
                                if (Toate = false)and(NiciUnul = false) then begin
                                  Butoane[1]:='Da'; Butoane[2]:='Nu';
                                  PromptWin.init(20, 12, 'Fisierul ' + k^.real_name + '.' + k^.real_ext +
                                                 ' exista. Doriti sa-l inlocuiti ?', 2, Butoane, LightGray, 'Interogare');
                                  Prompt_Value:=PromptWin.Select;
                                  PromptWin.done;

                                  PromptWin.init(20, 12, 'Acceptati alegerea pentru toate fisierele ?', 2, Butoane,
                                                 LightGray, 'Interogare');
                                  Prompt_Value2:=PromptWin.Select;
                                  PromptWin.done;

                                  if Prompt_Value2 = 'Da' then
                                    if Prompt_Value = 'Da' then Toate:=true
                                    else
                                      if Prompt_Value = 'Nu' then NiciUnul:=true
                                      else
                                  else;

                                  OsInfoWin.refresh;
                                end;
                              end;
                              OsInfoWin.InfoWin.SetFocus;
                              if ((Prompt_Value = 'Da')or(Toate = true))and(Exista = true) then begin
                                ChDir(RightMainWin.Cale);
                                if (LeftMainWin.ValidFileAttr(k^.real_name + '.' + k^.real_ext, ReadOnly) = true) then
                                  LeftMainWin.SetFileAttr(k^.real_name + '.' + k^.real_ext, Archive);
                                ExecCommand('del' + ' ' + k^.real_name + '.' + k^.real_ext);
                                ChDir(LeftMainWin.Cale);
                                ExecCommand('copy' + ' ' + k^.real_name + '.' + k^.real_ext + ' ' + RightMainWin.Cale);
                              end;
                              if ((Prompt_Value = 'Nu')or(Prompt_Value = '')or(NiciUnul = true))and(Exista = true) then ;
                              if (Exista = false) then
                                ExecCommand('copy' + ' ' + k^.real_name + '.' + k^.real_ext + ' ' + RightMainWin.Cale);

                              k^.selected:=false;
                              dec(SelectedItmNr);
                              SelectedItmSize:=SelectedItmSize + k^.size;
                              k^.name[8 + 1]:=' ';
                            end;
                            k:=k^.link;
                          end;
                          with CDMWin do begin
                            SetFocus;
                            j_aux:=Progress;
                            for i_aux:=(j_aux + 1) to 50 do
                              afisare(4, 3 + i_aux, chr(219), Black);
                            afisare(5, 4, s1 + ' ' + 'fisiere copiate' + '(100' +  + '%' + ')', Black);
                          end;
                          readkey;
                          CDMWin.done;
                          OsInfoWin.done;
                          Refresh;
                          with RightMainWin do begin
                            SetFocus;
                            ChDir(Cale);
                            DestructSortedContent(sant1, sant2);
                            BuildSortedContent(sant1, sant2, Sortare);
                            Refresh;
                          end;
                        end;

                      LeftMainWin.BuildCursor;
                      LeftMainWin.ShowCurentDir(Cyan);
                      LeftMainWin.ShowDrives1;
                      RightMainWin.ShowCurentDir(Blue);
                     end
                     else
                       if Prompt_Value3 = 'Nu' then begin                       end;
                         LeftMainWin.Refresh; RightMainWin.Refresh;
                         Refr1;
                       end;
          true: begin

                          if RightMainWin.SelectedItmNr = 0 then
                            RightMainWin.Select_FD;

                      Butoane[1]:='Da'; Butoane[2]:='Nu';
                      str(RightMainWin.SelectedItmNr, SelectedItm);
                      PromptWin.init(21, 2, 'Doriti sa copiati cele ' + SelectedItm + ' fisiere selectate din ' +
                                     RightMainWin.Cale + ' in ' + LeftMainWin.Cale + ' ?', 2, Butoane, LightGray,
                                     'Interogare');
                      Prompt_Value3:=PromptWin.Select;
                      PromptWin.done;

                      if Prompt_Value3 = 'Da' then begin


                        CDMWin.init(12, 2, 'Copiere', RightMainWin.Cale + '\',
                                    LeftMainWin.Cale + '\', RightMainWin.SelectedItmNr );
                        OsInfoWin.init(1, 12, 'Os Info');
                        Toate:=false; NiciUnul:=false; Prompt_Value:='';
                        with RightMainWin do begin
                          k:=sant1^.link;
                          while (k <> sant2) do begin
                            if (k^.tip = 'D')and(k^.selected = true) then begin
                              if (length(Cale) > 3) then
                                CopyDirectory(Cale + '\' + k^.real_name, LeftMainWin.Cale)
                              else
                                CopyDirectory(Cale + k^.real_name, LeftMainWin.Cale);
                              k^.selected:=false;
                              dec(SelectedItmNr);
                              SelectedItmSize:=SelectedItmSize + k^.size;
                              ChDir(Cale);
                            end
                            else
                            if (k^.tip = 'F')and(k^.selected = true) then begin
                              Exista:=false;
                              CDMWin.ShowMessage(k^.real_name + '.' + k^.real_ext);
                              if (LeftMainWin.FileExists(k^.real_name + '.' + k^.real_ext) = true) then begin
                                Exista:=true;
                                if (Toate = false)and(NiciUnul = false) then begin
                                  Butoane[1]:='Da'; Butoane[2]:='Nu';
                                  PromptWin.init(20, 12, 'Fisierul ' + k^.real_name + '.' + k^.real_ext +
                                                 ' exista. Doriti sa-l inlocuiti ?', 2, Butoane, LightGray, 'Interogare');
                                  Prompt_Value:=PromptWin.Select;
                                  PromptWin.done;

                                  PromptWin.init(20, 12, 'Acceptati alegerea pentru toate fisierele ?', 2, Butoane,
                                                 LightGray, 'Interogare');
                                  Prompt_Value2:=PromptWin.Select;
                                  PromptWin.done;

                                  if Prompt_Value2 = 'Da' then
                                    if Prompt_Value = 'Da' then Toate:=true
                                    else
                                      if Prompt_Value = 'Nu' then NiciUnul:=true
                                      else
                                  else;

                                  OsInfoWin.refresh;
                                end;
                              end;
                              OsInfoWin.InfoWin.SetFocus;
                              if ((Prompt_Value = 'Da')or(Toate = true))and(Exista = true) then begin
                                ChDir(LeftMainWin.Cale);
                                if (RightMainWin.ValidFileAttr(k^.real_name + '.' + k^.real_ext, ReadOnly) = true) then
                                  RightMainWin.SetFileAttr(k^.real_name + '.' + k^.real_ext, Archive);
                                ExecCommand('del' + ' ' + k^.real_name + '.' + k^.real_ext);
                                ChDir(RightMainWin.Cale);
                                ExecCommand('copy' + ' ' + k^.real_name + '.' + k^.real_ext + ' ' + LeftMainWin.Cale);
                              end;
                              if ((Prompt_Value = 'Nu')or(Prompt_Value = '')or(NiciUnul = true))and(Exista = true) then ;
                              if (Exista = false) then
                                ExecCommand('copy' + ' ' + k^.real_name + '.' + k^.real_ext + ' ' + LeftMainWin.Cale);

                              k^.selected:=false;
                              dec(SelectedItmNr);
                              SelectedItmSize:=SelectedItmSize + k^.size;
                              k^.name[8 + 1]:=' ';
                            end;
                            k:=k^.link;
                          end;
                          with CDMWin do begin
                            SetFocus;
                            j_aux:=Progress;
                            for i_aux:=(j_aux + 1) to 50 do
                              afisare(4, 3 + i_aux, chr(219), Black);
                            afisare(5, 4, s1 + ' ' + 'fisiere copiate' + '(100' +  + '%' + ')', Black);
                          end;
                          readkey;
                          CDMWin.done;
                          OsInfoWin.done;
                          Refresh;
                          with LeftMainWin do begin
                            SetFocus;
                            ChDir(Cale);
                            DestructSortedContent(sant1, sant2);
                            BuildSortedContent(sant1, sant2, Sortare);
                            Refresh;
                          end;
                        end;

                      RightMainWin.BuildCursor;
                      RightMainWin.ShowCurentDir(Cyan);
                      RightMainWin.ShowDrives1;
                      LeftMainWin.ShowCurentDir(Blue);
                    end
                     else
                       if Prompt_Value3 = 'Nu' then begin                       end;
                         LeftMainWin.Refresh; RightMainWin.Refresh;
                         Refr1;
                       end;
             end;
            end;
{ F8 }      #66: Label_Sterge:
                 case b of
             false: begin
                        if (LeftMainWin.SelectedItmNr = 0) then
                          LeftMainWin.Select_FD;

                      Butoane[1]:='Da'; Butoane[2]:='Nu';
                      str(LeftMainWin.SelectedItmNr, SelectedItm);
                      PromptWin.init(21, 2, 'Doriti sa stergeti cele ' + SelectedItm + ' fisiere selectate ?',
                                     2, Butoane, LightGray, 'Interogare');
                      Prompt_Value3:=PromptWin.Select;
                      PromptWin.done;

                      if Prompt_Value3 = 'Da' then begin
                        CDMWin.init(12, 2, 'Stergere', LeftMainWin.Cale + '\',
                        RightMainWin.Cale + '\', LeftMainWin.SelectedItmNr );
                        OsInfoWin.init(1, 12, 'Os Info');
                        Toate:=false; NiciUnul:=false;
                        with LeftMainWin do begin
                          k:=sant1^.link;
                          while (k <> sant2) do begin
                            if (k^.tip = 'D')and(k^.selected = true) then begin
                              if (length(Cale) > 3) then
                                DeleteDirectory(Cale + '\' + k^.real_name)
                              else
                                DeleteDirectory(Cale + k^.real_name);
                              ChDir(Cale);
                            end
                            else
                            if (k^.tip = 'F')and(k^.selected = true) then begin
                              CDMWin.SetFocus;
                              CDMWin.ShowMessage(k^.real_name + '.' + k^.real_ext);

                              Exista:=false;
                              if (LeftMainWin.ValidFileAttr(k^.real_name + '.' + k^.real_ext, ReadOnly) = true) then begin
                                Exista:=true;
                                if (Toate = false)and(NiciUnul = false) then begin

                                  Butoane[1]:='Da'; Butoane[2]:='Nu';
                                  PromptWin.init(20, 12, 'Fisierul ' + k^.real_name + '.' + k^.real_ext +
                                                 ' este ReadOnly ! Doriti sa-l stergeti ?',
                                                 2, Butoane, LightGray, 'Interogare');
                                  Prompt_Value:=PromptWin.Select;
                                  PromptWin.done;

                                  Butoane[1]:='Da'; Butoane[2]:='Nu';
                                  PromptWin.init(20, 12, 'Acceptati alegerea pentru toate fisierele ?',
                                                 2, Butoane, LightGray, 'Interogare');
                                  Prompt_Value2:=PromptWin.Select;
                                  PromptWin.done;

                                  if Prompt_Value2 = 'Da' then
                                    if Prompt_Value = 'Da' then Toate:=true
                                    else
                                      if Prompt_Value = 'Nu' then NiciUnul:=true
                                      else
                                  else;
                                  OsInfoWin.Refresh;
                                end;
                              end;

                              OsInfoWin.InfoWin.SetFocus;
                              if ((Prompt_Value = 'Da')or(Toate = true))and(Exista = true) then begin
                                LeftMainWin.SetFileAttr(k^.real_name + '.' + k^.real_ext, Archive);
                                ExecCommand('del' + ' ' + k^.real_name + '.' + k^.real_ext);
                              end;

                              if ((Prompt_Value = 'Nu')or(Prompt_Value = '')or(NiciUnul = true))and(Exista = true) then ;
                              if (Exista = false) then
                                ExecCommand('del' + ' ' + k^.real_name + '.' + k^.real_ext);

                              dec(SelectedItmNr);
                              SelectedItmSize:=SelectedItmSize + k^.size;
                            end;
                            k:=k^.link;
                          end;
                          with CDMWin do begin
                            SetFocus;
                            j_aux:=Progress;
                            for i_aux:=(j_aux + 1) to 50 do
                              afisare(4, 3 + i_aux, chr(219), Black);
                            afisare(5, 4, s1 + ' ' + 'fisiere sterse' + '(100' +  + '%' + ')', Black);
                          end;
                          CDMWin.done;
                          OsInfoWin.done;
                        end;
                      end;

                      if (LeftWinInfo = true) then begin
                        if LeftMainWin.Cale = RightMainWin.Cale then
                          with RightMainWin do begin
                            DestructSortedContent(sant1, sant2);
                            BuildSortedContent(sant1, sant2, Sortare);
                          end
                        else;
                        RightMainWin.SetFocus;
                        InformationWin.Refresh;
                        LeftMainWin.RefreshFTS(0);
                      end
                      else begin
                        LeftMainWin.RefreshFTS(0);
                        if LeftMainWin.Cale = RightMainWin.Cale then
                          RightMainWin.RefreshFTS(0)
                        else RightMainWin.Refresh;
                      end;

                      LeftMainWin.BuildCursor;
                      LeftMainWin.ShowCurentDir(Cyan);
                      LeftMainWin.ShowDrives1;
                      if (LeftWinInfo = false) then begin
                        RightMainWin.ShowDrives1;
                        RightMainWin.ShowCurentDir(blue);
                      end;
                    end;

             true: begin
                        if (RightMainWin.SelectedItmNr = 0) then
                          RightMainWin.Select_FD;

                      Butoane[1]:='Da'; Butoane[2]:='Nu';
                      str(RightMainWin.SelectedItmNr, SelectedItm);
                      PromptWin.init(21, 2, 'Doriti sa stergeti cele ' + SelectedItm + ' fisiere selectate ?',
                                     2, Butoane, LightGray, 'Interogare');
                      Prompt_Value3:=PromptWin.Select;
                      PromptWin.done;

                      if Prompt_Value3 = 'Da' then begin
                        CDMWin.init(12, 2, 'Stergere', RightMainWin.Cale + '\',
                                    LeftMainWin.Cale + '\', RightMainWin.SelectedItmNr );
                        OsInfoWin.init(1, 12, 'Os Info');
                        Toate:=false; NiciUnul:=false;
                        with RightMainWin do begin
                          k:=sant1^.link;
                          while (k <> sant2) do begin
                            if (k^.tip = 'D')and(k^.selected = true) then begin
                              if (length(Cale) > 3) then
                                DeleteDirectory(Cale + '\' + k^.real_name)
                              else
                                DeleteDirectory(Cale + k^.real_name);
                              ChDir(Cale);
                            end
                            else
                            if (k^.tip = 'F')and(k^.selected = true) then begin
                              CDMWin.SetFocus;
                              CDMWin.ShowMessage(k^.real_name + '.' + k^.real_ext);

                              Exista:=false;
                              if (RightMainWin.ValidFileAttr(k^.real_name + '.' + k^.real_ext, ReadOnly) = true) then begin
                                Exista:=true;
                                if (Toate = false)and(NiciUnul = false) then begin

                                  Butoane[1]:='Da'; Butoane[2]:='Nu';
                                  PromptWin.init(20, 12, 'Fisierul ' + k^.real_name + '.' + k^.real_ext +
                                                 ' este ReadOnly ! Doriti sa-l stergeti ?',
                                                 2, Butoane, LightGray, 'Interogare');
                                  Prompt_Value:=PromptWin.Select;
                                  PromptWin.done;

                                  Butoane[1]:='Da'; Butoane[2]:='Nu';
                                  PromptWin.init(20, 12, 'Acceptati alegerea pentru toate fisierele ?',
                                                 2, Butoane, LightGray, 'Interogare');
                                  Prompt_Value2:=PromptWin.Select;
                                  PromptWin.done;

                                  if Prompt_Value2 = 'Da' then
                                    if Prompt_Value = 'Da' then Toate:=true
                                    else
                                      if Prompt_Value = 'Nu' then NiciUnul:=true
                                      else
                                  else;
                                  OsInfoWin.Refresh;
                                end;
                              end;

                              OsInfoWin.InfoWin.SetFocus;
                              if ((Prompt_Value = 'Da')or(Toate = true))and(Exista = true) then begin
                                RightMainWin.SetFileAttr(k^.real_name + '.' + k^.real_ext, Archive);
                                ExecCommand('del' + ' ' + k^.real_name + '.' + k^.real_ext);
                              end;

                              if ((Prompt_Value = 'Nu')or(Prompt_Value = '')or(NiciUnul = true))and(Exista = true) then ;
                              if (Exista = false) then
                                ExecCommand('del' + ' ' + k^.real_name + '.' + k^.real_ext);

                              dec(SelectedItmNr);
                              SelectedItmSize:=SelectedItmSize + k^.size;
                            end;
                            k:=k^.link;
                          end;
                          with CDMWin do begin
                            SetFocus;
                            j_aux:=Progress;
                            for i_aux:=(j_aux + 1) to 50 do
                              afisare(4, 3 + i_aux, chr(219), Black);
                            afisare(5, 4, s1 + ' ' + 'fisiere sterse' + '(100' +  + '%' + ')', Black);
                          end;
                          CDMWin.done;
                          OsInfoWin.done;
                        end;
                      end;

                      if (RightWinInfo = true) then begin
                        if RightMainWin.Cale = LeftMainWin.Cale then
                          with LeftMainWin do begin
                            DestructSortedContent(sant1, sant2);
                            BuildSortedContent(sant1, sant2, Sortare);
                          end
                        else;
                        LeftMainWin.SetFocus;
                        InformationWin.Refresh;
                        RightMainWin.RefreshFTS(0);
                      end
                      else begin
                        RightMainWin.RefreshFTS(0);
                        if RightMainWin.Cale = LeftMainWin.Cale then
                          LeftMainWin.RefreshFTS(0)
                        else LeftMainWin.Refresh;
                      end;

                      RightMainWin.BuildCursor;
                      RightMainWin.ShowCurentDir(Cyan);
                      RightMainWin.ShowDrives1;
                      if (RightWinInfo = false) then begin
                        LeftMainWin.ShowDrives1;
                        LeftMainWin.ShowCurentDir(blue);
                      end;
                   end;
             end;
{      #64: Label_Muta:
           if (LeftWinInfo = false)and(RightWinInfo = false) then  begin
F6
           if (RightMainWin.Cale) = (LeftMainWin.Cale) then begin
             Butoane[1]:='OK';
             PromptWin.init(23, 5, 'Directorul sursa este identic cu directorul destinatie !', 1, Butoane, Red, 'Eroare');
             Prompt_Value:=PromptWin.Select;
             PromptWin.done;

             LeftMainWin.Refresh; RightMainWin.Refresh;
             Refr;
           end
           else
             case b of
               false: if ((LeftMainWin.SelectedItmNr = 0)and(LeftMainWin.k^.real_name = '..'))or
                      (LeftMainWin.SelectedFilesExist = false) then begin
                        Butoane[1]:='OK';
                        PromptWin.init(21, 5, 'Nici un fisier selectat !', 1, Butoane, Red, 'Eroare');
                        Prompt_Value:=PromptWin.Select;
                        PromptWin.done;

                        LeftMainWin.Refresh; RightMainWin.Refresh;
                        Refr;
                    end
                    else begin
                          if LeftMainWin.SelectedItmNr = 0 then
                            LeftMainWin.Select_FD;
                      Butoane[1]:='Da'; Butoane[2]:='Nu';
                      str(LeftMainWin.SelectedItmNr, SelectedItm);
                      PromptWin.init(21, 2, 'Doriti sa mutati cele ' + SelectedItm + ' fisiere selectate din ' +
                                     LeftMainWin.Cale + ' in ' + RightMainWin.Cale + ' ?', 2, Butoane, LightGray,
                                     'Interogare');
                      Prompt_Value3:=PromptWin.Select;
                      PromptWin.done;

                      if Prompt_Value3 = 'Da' then begin


                        CDMWin.init(12, 2, 'Mutare', LeftMainWin.Cale + '\',
                                    RightMainWin.Cale + '\', LeftMainWin.SelectedItmNr );
                        OsInfoWin.init(1, 12, 'Os Info');
                        with LeftMainWin do begin
                        k:=sant1^.link;
                        while (k <> sant2) do begin
                          if (k^.tip = 'F')and(k^.selected = true) then begin
                            CDMWin.SetFocus;
                            CDMWin.ShowMessage(k^.real_name + '.' + k^.real_ext);

                              Exista2:=false;
                              if (RightMainWin.FileExists(k^.real_name + '.' + k^.real_ext) = true) then begin
                                Exista2:=true;
                                if (Toate2 = false)and(NiciUnul2 = false) then begin
                                  Butoane[1]:='Da'; Butoane[2]:='Nu';
                                  PromptWin.init(20, 12, 'Fisierul ' + k^.real_name + '.' + k^.real_ext +
                                                 ' exista. Doriti sa-l inlocuiti ?', 2, Butoane, LightGray, 'Interogare');
                                  Prompt_Value4:=PromptWin.Select;
                                  PromptWin.done;

                                  PromptWin.init(20, 12, 'Acceptati alegerea pentru toate fisierele ?', 2, Butoane,
                                                 LightGray, 'Interogare');
                                  Prompt_Value5:=PromptWin.Select;
                                  PromptWin.done;

                                  if Prompt_Value5 = 'Da' then
                                    if Prompt_Value4 = 'Da' then Toate2:=true
                                    else
                                      if Prompt_Value4 = 'Nu' then NiciUnul2:=true
                                      else
                                  else;

                                  OsInfoWin.refresh;
                                end;
                              end;

                              Exista:=false;
                              if (LeftMainWin.ValidFileAttr(k^.real_name + '.' + k^.real_ext, ReadOnly) = true) then begin
                                Exista:=true;
                                if (Toate = false)and(NiciUnul = false) then begin

                                  Butoane[1]:='Da'; Butoane[2]:='Nu';
                                  PromptWin.init(20, 12, 'Fisierul ' + k^.real_name + '.' + k^.real_ext +
                                                 ' este ReadOnly ! Doriti sa-l mutati ?',
                                                 2, Butoane, LightGray, 'Interogare');
                                  Prompt_Value:=PromptWin.Select;
                                  PromptWin.done;

                                  Butoane[1]:='Da'; Butoane[2]:='Nu';
                                  PromptWin.init(20, 12, 'Acceptati alegerea pentru toate fisierele ?',
                                                 2, Butoane, LightGray, 'Interogare');
                                  Prompt_Value2:=PromptWin.Select;
                                  PromptWin.done;

                                  if Prompt_Value2 = 'Da' then
                                    if Prompt_Value = 'Da' then Toate:=true
                                    else
                                      if Prompt_Value = 'Nu' then NiciUnul:=true
                                      else
                                  else;
                                  OsInfoWin.Refresh;
                                end;
                              end;

                              OsInfoWin.InfoWin.SetFocus;
                              if ((Prompt_Value = 'Da')or(Toate = true))and(Exista = true) then
                                if ((Prompt_Value4 = 'Da')or(Toate2 = true))and(Exista2 = true) then begin
                                  ChDir(RightMainWin.Cale);
                                  if (LeftMainWin.ValidFileAttr(k^.real_name + '.' + k^.real_ext, ReadOnly) = true) then
                                    LeftMainWin.SetFileAttr(k^.real_name + '.' + k^.real_ext, Archive);
                                  ExecCommand('del' + ' ' + k^.real_name + '.' + k^.real_ext);
                                  ChDir(LeftMainWin.Cale);
                                  ExecCommand('copy' + ' ' + k^.real_name + '.' + k^.real_ext + ' ' + RightMainWin.Cale);
                                  LeftMainWin.SetFileAttr(k^.real_name + '.' + k^.real_ext, Archive);
                                  ExecCommand('del' + ' ' + k^.real_name + '.' + k^.real_ext);
                                end;
                                if ((Prompt_Value4 = 'Nu')or(Prompt_Value4 = '')or(NiciUnul2 = true))and(Exista = true) then ;
                                if (Exista2 = false) then begin
                                  ExecCommand('copy' + ' ' + k^.real_name + '.' + k^.real_ext + ' ' + RightMainWin.Cale);
                                  LeftMainWin.SetFileAttr(k^.real_name + '.' + k^.real_ext, Archive);
                                  ExecCommand('del' + ' ' + k^.real_name + '.' + k^.real_ext);
                                end;

                              if ((Prompt_Value = 'Nu')or(Prompt_Value = '')or(NiciUnul = true))and(Exista = true) then ;
                              if (Exista = false) then
                                if ((Prompt_Value4 = 'Da')or(Toate2 = true))and(Exista2 = true) then begin
                                  ChDir(RightMainWin.Cale);
                                  if (LeftMainWin.ValidFileAttr(k^.real_name + '.' + k^.real_ext, ReadOnly) = true) then
                                    LeftMainWin.SetFileAttr(k^.real_name + '.' + k^.real_ext, Archive);
                                  ExecCommand('del' + ' ' + k^.real_name + '.' + k^.real_ext);
                                  ChDir(LeftMainWin.Cale);
                                  ExecCommand('copy' + ' ' + k^.real_name + '.' + k^.real_ext + ' ' + RightMainWin.Cale);
                                  ExecCommand('del' + ' ' + k^.real_name + '.' + k^.real_ext);
                                end;
                                if ((Prompt_Value4 = 'Nu')or(Prompt_Value4 = '')or(NiciUnul2 = true))and(Exista = true) then ;
                                if (Exista2 = false) then begin
                                  ExecCommand('copy' + ' ' + k^.real_name + '.' + k^.real_ext + ' ' + RightMainWin.Cale);
                                  ExecCommand('del' + ' ' + k^.real_name + '.' + k^.real_ext);
                                end;

                            dec(SelectedItmNr);
                            SelectedItmSize:=SelectedItmSize + k^.size;
                          end;
                          k:=k^.link;
                        end;
                        CDMWin.done;
                        OsInfoWin.done;
                        RightMainWin.RefreshFTS(0);
                        RefreshFTS(0);
                      end;

                      LeftMainWin.BuildCursor;
                      LeftMainWin.ShowCurentDir(Cyan);
                      LeftMainWin.ShowDrives1;
                      RightMainWin.ShowCurentDir(Blue);
                    end
                     else
                       if Prompt_Value3 = 'Nu' then begin                       end;
                         LeftMainWin.Refresh; RightMainWin.Refresh;
                         Refr;
                       end;
           true: ;
         end;
       end;}

      #32: case b of   { SpaceBar }
             false: LeftMainWin.Select_FD;
             true: RightMainWin.Select_FD;
           end;
      #42: case b of   { * }
             false: with LeftMainWin do begin
                      DestructCursor;
                      ClearMainWin; { sterge dir. si fis. de pe ecran }
                      ini; { cursor }
                      selectie:=sant1^.link;
                      while (selectie <> sant2) do begin
                        if (selectie^.tip = 'F') then begin
                          selectie^.selected:=not selectie^.selected;
                          case selectie^.selected of
                            true: begin
                                    inc(SelectedItmNr);
                                    SelectedItmSize:=SelectedItmSize + selectie^.size;
                                  end;
                            false: begin
                                     dec(SelectedItmNr);
                                     SelectedItmSize:=SelectedItmSize - selectie^.size;
                                   end;
                          end;
                          if selectie^.selected = true then
                            selectie^.name[8 + 1]:=chr(251) { radical }
                          else selectie^.name[8 + 1]:=' ';
                        end;
                        selectie:=selectie^.link;
                      end;
                      ShowSortedContent;
                      BuildCursor;
                      ShowSelectedInfo;
                    end;
             true: with RightMainWin do begin
                      DestructCursor;
                      ClearMainWin; { sterge dir. si fis. de pe ecran }
                      ini; { cursor }
                      selectie:=sant1^.link;
                      while (selectie <> sant2) do begin
                        if (selectie^.tip = 'F') then begin
                          selectie^.selected:=not selectie^.selected;
                          case selectie^.selected of
                            true: begin
                                    inc(SelectedItmNr);
                                    SelectedItmSize:=SelectedItmSize + selectie^.size;
                                  end;
                            false: begin
                                     dec(SelectedItmNr);
                                     SelectedItmSize:=SelectedItmSize - selectie^.size;
                                   end;
                          end;
                          if selectie^.selected = true then
                            selectie^.name[8 + 1]:=chr(251) { radical }
                          else selectie^.name[8 + 1]:=' ';
                        end;
                        selectie:=selectie^.link;
                      end;
                      ShowSortedContent;
                      BuildCursor;
                      ShowSelectedInfo;

                   end;
           end;
      #45: begin
             goto Label_Deselecteaza_Grup;
             Label_DG_Revenire:
           end;

      #43: Label_Selecteaza_Grup:
           begin
             MkDirWin.init(25, 5, 'Selecteaza', 'Grup');
             Grup:=MkDirWin.GetDir(Grup);

             GNume:=''; GExt:='';
             if (Grup <> '') then begin
               GCont:=0;
               while (Grup[GCont] <> '.')and(GCont < length(Grup)) do
                 inc(GCont);
               if Grup[GCont] = '.' then begin
                 GNume:=copy(Grup, 1, GCont - 1);
                 GExt:=copy(Grup, GCont + 1, length(Grup) - GCont);
               end
               else
                 if GCont = length(Grup) then begin
                   GNume:=Grup;
                   GExt:='';
                 end;
             end;

             if (GNume <> '')and(GExt <> '.') then
               case b of
                 false: with LeftMainWin do begin
                          selectie:=sant1^.link;
                          while (selectie <> sant2) do begin
                            if (selectie^.tip = 'F')and(((GNume = '*')and(GExt = '*'))or
                               ((GNume = selectie^.real_name)and(GExt = '*'))or
                               ((GNume = '*')and(GExt = selectie^.real_ext))or
                               ((GNume = selectie^.real_name)and(GExt = selectie^.real_ext)))
                            then
                              if (selectie^.selected = false) then begin
                                selectie^.selected:=true;
                                inc(SelectedItmNr);
                                SelectedItmSize:=SelectedItmSize + selectie^.size;
                                selectie^.name[8 + 1]:=chr(251) { radical }
                              end
                              else;
                            selectie:=selectie^.link;
                          end;
                        end;
                 true: with RightMainWin do begin
                          selectie:=sant1^.link;
                          while (selectie <> sant2) do begin
                            if (selectie^.tip = 'F')and(((GNume = '*')and(GExt = '*'))or
                               ((GNume = selectie^.real_name)and(GExt = '*'))or
                               ((GNume = '*')and(GExt = selectie^.real_ext))or
                               ((GNume = selectie^.real_name)and(GExt = selectie^.real_ext)))
                            then
                              if (selectie^.selected = false) then begin
                                selectie^.selected:=true;
                                inc(SelectedItmNr);
                                SelectedItmSize:=SelectedItmSize + selectie^.size;
                                selectie^.name[8 + 1]:=chr(251) { radical }
                              end
                              else;
                            selectie:=selectie^.link;
                          end;
                       end;
               end;

             LeftMainWin.Refresh; RightMainWin.Refresh; Refr1;
           end;

      #61: goto Label_Help;

      #27: Label_Iesire:
           begin
             Butoane[1]:='Da'; Butoane[2]:='Nu';
             PromptWin.init(21, 5, 'Doriti sa inchideti aplicatia?', 2, Butoane, LightGray, 'Interogare');
             Prompt_Value:=PromptWin.Select;
             if Prompt_Value = 'Da' then begin
               ChDir('d:\tp7\Comander\C_v11');
               PromptWin.done; LeftMainWin.done; RightMainWin.done;
               b_Exit:=true;
               LeftMainWin.done; RightMainWin.done;
               SubMenuBarWin.DestructSubMenuBar;
               halt(1);
             end
             else begin
               PromptWin.done;

               Refr2; Refr1;
             end;
           end;
      {else begin
        if c = #8 then Delete(ReaderWin.Sir,length(ReaderWin.Sir), 1)
        else ReaderWin.Sir:=ReaderWin.Sir + c;
          ReaderWin.SetFocus; ReaderWin.SelectReaderWin;
      end;}
    end;
  until b_Exit = true;


  Label_Deselecteaza_Grup:

    MkDirWin.init(25, 5, 'Selecteaza', 'Grup');
    Grup:=MkDirWin.GetDir(Grup);

    GNume:=''; GExt:='';
    if (Grup <> '') then begin
      GCont:=0;
      while (Grup[GCont] <> '.')and(GCont < length(Grup)) do
        inc(GCont);
        if Grup[GCont] = '.' then begin
          GNume:=copy(Grup, 1, GCont - 1);
          GExt:=copy(Grup, GCont + 1, length(Grup) - GCont);
        end
        else
          if GCont = length(Grup) then begin
            GNume:=Grup;
            GExt:='';
          end;
        end;

        if (GNume <> '')and(GExt <> '.') then
          case b of
            false: with LeftMainWin do begin
                     selectie:=sant1^.link;
                     while (selectie <> sant2) do begin
                       if (selectie^.tip = 'F')and(((GNume = '*')and(GExt = '*'))or
                          ((GNume = selectie^.real_name)and(GExt = '*'))or
                          ((GNume = '*')and(GExt = selectie^.real_ext))or
                          ((GNume = selectie^.real_name)and(GExt = selectie^.real_ext)))
                       then
                       if (selectie^.selected = true) then begin
                         selectie^.selected:=false;
                         dec(SelectedItmNr);
                         SelectedItmSize:=SelectedItmSize - selectie^.size;
                         selectie^.name[8 + 1]:=' '; { radical }
                       end
                       else;
                     selectie:=selectie^.link;
                   end;
                   end;
            true: with RightMainWin do begin
                     selectie:=sant1^.link;
                     while (selectie <> sant2) do begin
                       if (selectie^.tip = 'F')and(((GNume = '*')and(GExt = '*'))or
                          ((GNume = selectie^.real_name)and(GExt = '*'))or
                          ((GNume = '*')and(GExt = selectie^.real_ext))or
                          ((GNume = selectie^.real_name)and(GExt = selectie^.real_ext)))
                       then
                       if (selectie^.selected = true) then begin
                         selectie^.selected:=false;
                         dec(SelectedItmNr);
                         SelectedItmSize:=SelectedItmSize - selectie^.size;
                         selectie^.name[8 + 1]:=' '; { radical }
                       end
                       else;
                     selectie:=selectie^.link;
                   end;
                        end;
    end;
   LeftMainWin.Refresh; RightMainWin.Refresh; Refr1;
   goto Label_DG_Revenire;

   Label_Cauta:
     SearchWin.init(16, 3);
     SearchWin.Navigate(FMask, FName, TipCautare, DestinatieCautare);
     SearchWin.done;

     LeftMainWin.refresh; RightMainWin.refresh;
     refr2; refr1;

     if (FMask <> '') then begin
       case b of
         false: begin
                  if DestinatieCautare = 'Tot discul' then
                    SearchForFilesWin.init(6, 4, FMask, LeftMainWin.Curent_Drive + ':\', Director_Curent + '\' + 'Res')
                  else
                    if DestinatieCautare = 'Director curent' then
                      SearchForFilesWin.init(6, 4, FMask, LeftMainWin.Cale, Director_Curent + '\' + 'Res');
                  DirectorulFisieruluiCautat:=SearchForFilesWin.Navigate(FisierCautat);
                  SearchForFilesWin.done;
                  if DirectorulFisieruluiCautat <> '' then
                    LeftMainWin.Cale:=DirectorulFisieruluiCautat;
                  RightMainWin.refresh; LeftMainWin.RefreshFTS(0);
                  refr2; refr1;
                  with LeftMainWin do
                    while ((k^.real_name + '.' + k^.real_ext) <> FisierCautat)and
                          (k^.link <> sant2) do
                      MoveCursorDown;
                  if LeftWinInfo = true then begin
                    RightMainWin.SetFocus;
                    with LeftMainWin do
                      InformationWin.init(Cale, Curent_Drive, sant1, sant2);
                  end;
                end;
         true: begin
                  if DestinatieCautare = 'Tot discul' then
                    SearchForFilesWin.init(6, 4, FMask, RightMainWin.Curent_Drive + ':\', Director_Curent + '\' + 'Res')
                  else
                    if DestinatieCautare = 'Director curent' then
                      SearchForFilesWin.init(6, 4, FMask, RightMainWin.Cale, Director_Curent + '\' + 'Res');
                  DirectorulFisieruluiCautat:=SearchForFilesWin.Navigate(FisierCautat);
                  SearchForFilesWin.done;
                  if DirectorulFisieruluiCautat <> '' then
                    RightMainWin.Cale:=DirectorulFisieruluiCautat;
                  LeftMainWin.refresh; RightMainWin.RefreshFTS(0);
                  refr2; refr1;
                  with RightMainWin do
                    while ((k^.real_name + '.' + k^.real_ext) <> FisierCautat)and
                          (k^.link <> sant2) do
                      MoveCursorDown;
                  if RightWinInfo = true then begin
                    LeftMainWin.SetFocus;
                    with RightMainWin do
                      InformationWin.init(Cale, Curent_Drive, sant1, sant2);
                  end;
               end;
       end;
     end;
   goto Label_Cauta_Revenire;

   Label_ExecutaOS:
   goto Label_ExecutaOS_Revenire;

   Label_Help:
     HelpWin.init(1, 1, 79, 20, Director_Curent + '\Res\Help.hlp', Director_Curent + '\Res\');
     HelpWin.done;

     LeftMainWin.refresh; RightMainWin.refresh;
     refr2; refr1;
   goto Label_Help_Revenire;

   Label_UnderConstruction:
     Butoane[1]:='OK';
     PromptWin.init(21, 5, 'Method under construction !', 1, Butoane, LightGray, 'Interogare');
     Prompt_Value:=PromptWin.Select;
     PromptWin.done;

     LeftMainWin.refresh; RightMainWin.refresh;
     refr2; refr1;
   goto Label_UnderConstruction_Revenire;

end.