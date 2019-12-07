program Playlist;
uses crt;
type Waktu=record
        Jam,Menit,Detik:integer;
        end;
type KomponenLagu=record
        Judul,Penyanyi,Genre:string;
        Diputar:boolean;
        ID:integer;
        Durasi:waktu;
        end;
var
        Lagu:array[1..100] of KomponenLagu;
        ID:integer;
        Exit:boolean;

        //mengecheck Judul Penyanyi
        function CheckJudulPenyanyi(judul,penyanyi:string;ID:integer;Lagu:array of KomponenLagu;var urutan:integer):boolean;
                var
                        i,kondisi:integer;
                begin
                        i:=0;kondisi:=0;
                        repeat
                                i:=i+1;
                                if((lowercase(judul)=lowercase(Lagu[i].Judul))and(lowercase(penyanyi)=lowercase(Lagu[i].Penyanyi)))then
                                        begin
                                                kondisi:=1;
                                                urutan:=i;
                                        end;

                        until(i=ID);
                        if(kondisi=0)then
                                CheckJudulPenyanyi:=true
                        else
                                CheckJudulPenyanyi:=false;
                end;

        //mengcheck genre
        function CheckGenre(var genre:string):boolean;
                var
                        GenreOpt:array[1..3] of string;
                        kondisi:integer;
                        i:integer;
                begin
                        i:=0;kondisi:=0;
                        GenreOpt[1]:='Art';
                        GenreOpt[2]:='Populer';
                        GenreOpt[3]:='Tradisional';
                        repeat
                                i:=i+1;
                                if(lowercase(genre)=lowercase(GenreOpt[i]))then
                                        begin
                                                genre:=GenreOpt[i];
                                                kondisi:=1;
                                        end
                        until(i=3);
                        if(kondisi=1)then
                                CheckGenre:=true
                        else
                                CheckGenre:=false;
                end;

        //mengcheck durasi
        function CheckDurasi(jam,menit,detik:integer):boolean;
                begin
                        if(jam in [0..23])then
                                begin
                                        if((menit in [0..59])and(detik in[0..59]))then
                                                CheckDurasi:=true
                                        else
                                                begin
                                                        writeln('Masukan Detik Atau Menit Invalid');
                                                        CheckDurasi:=false;
                                                end;
                                end
                        else if(jam=24)then
                                begin
                                        if((menit=0)and(detik=0))then
                                                CheckDurasi:=true
                                        else
                                                begin
                                                        writeln('Masukan Menit Atau Detik Invalid');
                                                        CheckDurasi:=false;
                                                end;
                                end
                        else
                                begin
                                        //jika input tidak valid
                                        writeln('Masukan Jam Invalid');
                                        CheckDurasi:=false;
                                end;
                end;

        //mengcheck kecocokan genre
        function CheckJudulGenre(genre:string;ID:integer;var i,j:integer;Lagu:array of KomponenLagu;var ArrGenre:array of KomponenLagu):boolean;
                var
                        kondisi:integer;
                begin
                        kondisi:=0;
                        repeat
                                i:=i+1;
                                if(lowercase(genre)=lowercase(Lagu[i].Genre))then
                                        begin
                                                j:=j+1;
                                                ArrGenre[j-1]:=Lagu[i];
                                                kondisi:=1;
                                        end
                        until((i=ID)or(lowercase(genre)=lowercase(Lagu[i].Genre)));
                        if(kondisi=1)then
                                CheckJudulGenre:=true
                        else
                                CheckJudulGenre:=false;
                end;

        procedure tampilkan(i,ID:integer;Lagu:array of KomponenLagu);
                begin
                        repeat
                                i:=i+1;
                                write('Song-0');if(Lagu[i].ID<10)then write('0',Lagu[i].ID) else write(Lagu[i].ID);
                                writeln(' ',Lagu[i].Judul,' - ',Lagu[i].Penyanyi,'.');
                                writeln('       * Genre : ',Lagu[i].Genre);
                                writeln('       * Durasi : ',Lagu[i].Durasi.Jam,'h - ',Lagu[i].Durasi.Menit,'m - ',Lagu[i].Durasi.Detik,'s.');
                                writeln('       * Status Diputar : ',Lagu[i].Diputar);
                                writeln();
                        until(i>=ID);
                end;

        procedure insertion(i,ID:integer;var ArrLagu:array of KomponenLagu);
                var
                        h,k,j:integer;
                        con:boolean;
                        temp:KomponenLagu;
                begin
                        h:=i;
                        repeat
                                i:=i+1;
                                j:=i;
                                con:=false;
                                repeat
                                        if(ArrLagu[j].Judul<ArrLagu[j-1].Judul)then
                                                begin
                                                        temp:=ArrLagu[j-1];
                                                        ArrLagu[j-1]:=ArrLagu[j];
                                                        ArrLagu[j]:=temp;
                                                end;
                                        j:=j-1;
                                        if(j>0)then
                                                con:=ArrLagu[j].Judul<ArrLagu[j-1].Judul;
                                until((j=h)or not con);
                        until(i>=ID-1);
                end;

        //mengurutkan lagu
        procedure UrutkanSesuaiGenreJudul(genre:string;ID:integer;var Lagu,ArrGenre:array of KomponenLagu);
                var
                        i,j,jumlah:integer;
                        temp:komponenLagu;
                begin
                        i:=0;j:=0;jumlah:=0;
                        repeat
                                if(CheckJudulGenre(genre,ID,i,j,Lagu,ArrGenre))then
                                        begin jumlah:=jumlah+1; end;
                        until(i=ID);
                        if(ID>1)then
                        begin
                                i:=0;
                                insertion(i,jumlah,ArrGenre);
                                i:=-1;
                                tampilkan(i,jumlah-1,ArrGenre);
                        end
                        else if(ID=1)then
                        begin
                                i:=-1;
                                tampilkan(i,jumlah-1,ArrGenre);
                        end;
                end;

        //mengurutkan lagu dari durasi
        procedure UrutkanSesuaiDurasi(ID:integer;var Lagu:array of KomponenLagu);
                var
                        i,j,k,laguid:integer;
                begin
                        i:=-1;
                        repeat
                                i:=i+1;j:=-1;
                                repeat
                                        j:=j+1;k:=-1;
                                        repeat
                                                k:=k+1;laguid:=0;
                                                repeat
                                                        laguid:=laguid+1;
                                                        if((i=Lagu[laguid].Durasi.Jam)and(j=Lagu[laguid].Durasi.Menit)and(k=Lagu[laguid].Durasi.Detik))then
                                                                begin
                                                                        write('Song-0');if(laguid<10)then write('0',laguid) else write(laguid);
                                                                        writeln(' ',Lagu[laguid].Judul,' - ',Lagu[laguid].Penyanyi,'.');
                                                                        writeln('       * Genre : ',Lagu[laguid].Genre);
                                                                        writeln('       * Durasi : ',Lagu[laguid].Durasi.Jam,'h - ',Lagu[laguid].Durasi.Menit,'m - ',Lagu[laguid].Durasi.Detik,'s.');
                                                                        writeln('       * Status Diputar : ',Lagu[laguid].Diputar);
                                                                        writeln();
                                                                end;
                                                until(laguid=ID);
                                        until(k=59);
                                until(j=59);
                        until(i=23);
                end;

        //mengurutkan dengan durasi dan genre
        procedure UrutkanSesuaiGenre(genre:string;ID:integer;var Lagu:array of KomponenLagu);
                var
                        i,j,k,laguid:integer;
                begin
                        i:=-1;
                        repeat
                                i:=i+1;j:=-1;
                                repeat
                                        j:=j+1;k:=-1;
                                        repeat
                                                k:=k+1;laguid:=0;
                                                repeat
                                                        laguid:=laguid+1;
                                                        if((genre=Lagu[laguid].Genre)and(i=Lagu[laguid].Durasi.Jam)and(j=Lagu[laguid].Durasi.Menit)and(k=Lagu[laguid].Durasi.Detik))then
                                                                begin
                                                                        write('Song-0');if(laguid<10)then write('0',laguid) else write(laguid);
                                                                        writeln(' ',Lagu[laguid].Judul,' - ',Lagu[laguid].Penyanyi,'.');
                                                                        writeln('       * Genre : ',Lagu[laguid].Genre);
                                                                        writeln('       * Durasi : ',Lagu[laguid].Durasi.Jam,'h - ',Lagu[laguid].Durasi.Menit,'m - ',Lagu[laguid].Durasi.Detik,'s.');
                                                                        writeln('       * Status Diputar : ',Lagu[laguid].Diputar);
                                                                        writeln();
                                                                end;
                                                until(laguid=ID);
                                        until(k=59);
                                until(j=59);
                        until(i=23);
                end;

        //input Judul Penyanyi
        procedure InputJudulPenyanyi(ID:integer;var Lagu:array of KomponenLagu;var Status:boolean);
                var
                        judul,penyanyi:string;
                        urutan:integer; //untuk mendapatkan ID
                begin
                        write('Judul : ');readln(judul);
                        writeln('===================================');
                        write('Penyanyi : ');readln(penyanyi);
                        writeln('===================================');
                        if(CheckJudulPenyanyi(judul,penyanyi,ID,Lagu,urutan))then
                                begin
                                        status:=true;
                                        Lagu[ID].Judul:=judul;
                                        Lagu[ID].Penyanyi:=penyanyi;
                                end
                        else
                                begin
                                        status:=false;
                                        writeln('Masukan Invalid : Lagu Terdaftar');
                                end;
                end;

        //input genre
        procedure InputGenre(ID:integer;var Lagu:array of KomponenLagu);
                var
                        genre:string;
                begin
                        writeln('Masukan Genre diantara Art,Populer,dan Tradisional');
                        repeat
                                write('Genre : ');readln(genre);
                                writeln('===================================');
                                if(not CheckGenre(genre))then
                                        writeln('Masukan Invalid : Genre Tidak Sesuai');
                        until(CheckGenre(genre));
                        Lagu[ID].Genre:=genre;
                end;

        //input durasi
        procedure InputDurasi(ID:integer;var Lagu:array of KomponenLagu);
                var
                        jam,menit,detik:integer;
                begin
                        repeat
                                write('Masukan Durasi [Jam Menit Detik] : ');
                                read(jam);read(menit);read(detik);
                                writeln('===================================');
                        until(CheckDurasi(jam,menit,detik));
                        Lagu[ID].Durasi.Jam:=jam;
                        Lagu[ID].Durasi.Menit:=menit;
                        Lagu[ID].Durasi.Detik:=detik;
                end;

        //Menyusun ulang List
        procedure SusunUlang(var ID:integer;var Lagu:array of Komponenlagu;urutan:integer);
                var
                        m:integer;
                begin
                        m:=urutan-1;
                        repeat
                                m:=m+1;
                                Lagu[m].Judul:=Lagu[m+1].Judul;
                                Lagu[m].Penyanyi:=Lagu[m+1].Penyanyi;
                                Lagu[m].Genre:=Lagu[m+1].Genre;
                                Lagu[m].Diputar:=Lagu[m+1].Diputar;
                                Lagu[m].Durasi.Jam:=Lagu[m+1].Durasi.Jam;
                                Lagu[m].Durasi.Menit:=Lagu[m+1].Durasi.Menit;
                                Lagu[m].Durasi.Detik:=Lagu[m+1].Durasi.Detik;
                        until(m=ID-1);
                        ID:=ID-1;
                end;

        //1.Tambah Lagu
        procedure TambahLagu(var ID:integer;var Lagu:array of KomponenLagu);
                var
                        judulpenyanyi:boolean;
                begin
                        ID:=ID+1;
                        writeln('1. Tambah Lagu');
                        writeln('Menambahkan Lagu Pada Urutan Ke-',ID);
                        writeln('===================================');
                        InputJudulPenyanyi(ID,Lagu,judulpenyanyi);
                        if(not judulpenyanyi)then
                                begin
                                        //clrscr;
                                        ID:=ID-1;
                                        writeln('Judul : Invalid');
                                        writeln('Penyanyi : Invalid');
                                        writeln('Genre : Invalid');
                                        writeln('Durasi : Invalid');
                                end
                        else
                                begin
                                        InputGenre(ID,Lagu);
                                        InputDurasi(ID,Lagu);
                                        Lagu[ID].Diputar:=true;
                                        Lagu[ID].ID:=ID;
                                end;
                        writeln();
                        writeln('Tekan Apapun Untuk Melanjutkan');
                        readkey();
                        clrscr;
                end;

        //2. LewatiLagu
        procedure LewatiLagu(var ID:integer;var Lagu:array of KomponenLagu);
                var
                        judul,penyanyi:string;
                        urutan:integer;
                begin
                        writeln('2. Lewati Lagu');
                        writeln('===================================');
                        write('Judul : ');readln(judul);
                        writeln('===================================');
                        write('Penyanyi : ');readln(penyanyi);
                        writeln('===================================');
                        if(ID in [1..100])then
                        begin
                        if((not CheckJudulPenyanyi(judul,penyanyi,ID,Lagu,urutan)))then
                                begin
                                        Lagu[urutan].Diputar:=false;
                                        write('Song-0');
                                        if(urutan<10)then write('0',urutan,' ')
                                        else write(urutan,' ');
                                        writeln(Lagu[urutan].Judul,' - ',Lagu[urutan].Penyanyi,'.');
                                        writeln('Lagu Ditemukan Dan Akan Dilewatkan');
                                        writeln('Status Diputar Diset Ke False');
                                end
                        end
                        else
                                writeln('Masukan Invalid : Lagu Tidak Terdaftar');
                        writeln();
                        writeln('Tekan Apapun Untuk Melanjutkan');
                        readkey();
                        clrscr;
                end;

        //3. Hapus Lagu
        procedure HapusLagu(var ID:integer;var Lagu:array of KomponenLagu);
                var
                        judul,penyanyi:string;
                        urutan:integer;
                begin
                        writeln('3. Hapus Lagu');
                        writeln('===================================');
                        write('Judul : ');readln(judul);
                        writeln('===================================');
                        write('Penyanyi : ');readln(penyanyi);
                        writeln('===================================');
                        if(ID in [1..100])then
                        begin
                        if((not CheckJudulPenyanyi(judul,penyanyi,ID,Lagu,urutan)))then
                                begin
                                        write('Song-0');
                                        if(urutan<10)then write('0',urutan,' ')
                                        else write(urutan,' ');
                                        writeln(Lagu[urutan].Judul,' - ',Lagu[urutan].Penyanyi,'.');
                                        writeln('Lagu Ditemukan Dan Akan Dihapus');
                                        writeln('Susunan Playlist akan Disusun Ulang');
                                        if(ID>2)then
                                                SusunUlang(ID,Lagu,urutan)
                                        else
                                                ID:=0;
                                end;
                        end
                        else
                                writeln('Masukan Invalid : Lagu Tidak Terdaftar');
                        writeln();
                        writeln('Tekan Apapun Untuk Melanjutkan');
                        readkey();
                        clrscr;
                end;

        //4. Putar Lagu
        procedure PutarLagu(var ID:integer;var Lagu:array of KomponenLagu);
                var
                        judul,penyanyi:string;
                        urutan,i:integer;
                begin
                        writeln('4. Putar Lagu');
                        writeln('===================================');
                        write('Judul : ');readln(judul);
                        writeln('===================================');
                        write('Penyanyi : ');readln(penyanyi);
                        writeln('===================================');
                        if(ID in [1..100])then
                        begin
                        if((not CheckJudulPenyanyi(judul,penyanyi,ID,Lagu,urutan)))then
                                begin
                                        i:=urutan-1;
                                        repeat
                                                i:=i+1;
                                                if(Lagu[i].Diputar)then
                                                        begin
                                                                 write('Song-0');
                                                                 if(urutan<10)then write('0',i,' ')
                                                                 else write(i,' ');
                                                                 writeln(Lagu[i].Judul,' - ',Lagu[i].Penyanyi,'.');
                                                        end;
                                        until(i=ID);
                                end;
                        end
                        else
                                writeln('Masukan Invalid : Lagu Tidak Terdaftar');
                        writeln();
                        writeln('Tekan Apapun Untuk Melanjutkan');
                        readkey();
                        clrscr;
                end;

        //5. Menampilkan Data Sebuah Lagu tertentu
        procedure MenampilkanDataSatuLaguTertentu(var ID:integer;var Lagu:array of KomponenLagu);
                var
                        judul,penyanyi:string;
                        urutan:integer;
                begin
                        writeln('5. Menampilkan Data Satu Lagu Tertentu');
                        writeln('===================================');
                        write('Judul : ');readln(judul);
                        writeln('===================================');
                        write('Penyanyi : ');readln(penyanyi);
                        writeln('===================================');
                        if(ID in [1..100])then
                        begin
                        if(not(CheckJudulPenyanyi(judul,penyanyi,ID,Lagu,urutan)))then
                                begin
                                        write('Song-0');if(urutan<10)then write('0',urutan) else write(urutan);
                                        writeln(' ',Lagu[urutan].Judul,' - ',Lagu[urutan].Penyanyi,'.');
                                        writeln('       * Genre : ',Lagu[urutan].Genre);
                                        writeln('       * Durasi : ',Lagu[urutan].Durasi.Jam,'h - ',Lagu[urutan].Durasi.Menit,'m - ',Lagu[urutan].Durasi.Detik,'s.');
                                        writeln('       * Status Diputar : ',Lagu[urutan].Diputar);
                                end;
                        end
                        else
                                writeln('Masukan Invalid : Lagu Tidak Terdaftar atau Playlist Kosong');
                        writeln();
                        writeln('Tekan Apapun Untuk Melanjutkan');
                        readkey();
                        clrscr;
                end;

        //6. Menampilkan Jumlah Lagu PerGenre Tertentu
        procedure MenampilkanJumlahLaguPer_GenreTertentu(var ID:integer;var Lagu:array of KomponenLagu);
                var
                        i,j,jumlah:integer;
                        ArrGenre:array[1..100] of Komponenlagu;
                        genre:string;
                begin
                        writeln('6. Menampilkan Jumlah Lagu Per-Genre Tertentu');
                        writeln('===================================');
                        writeln('Masukan Genre diantara Art,Populer,dan Tradisional');
                        write('Genre : ');readln(genre);
                        writeln('===================================');
                        if(ID=0)then
                                writeln('Playlist Kosong')
                        else if(not CheckGenre(genre))then
                                writeln('Masukan Invalid : Genre Tidak Sesuai')
                        else if(CheckGenre(genre))then
                                begin
                                        i:=0;j:=0;jumlah:=0;
                                        repeat
                                                if(CheckJudulGenre(genre,ID,i,j,Lagu,ArrGenre))then
                                                        begin
                                                                jumlah:=jumlah+1;
                                                                write('Song-0');if(i<10)then write('0',i) else write(i);
                                                                writeln(' ',ArrGenre[j].Judul,' - ',ArrGenre[j].Penyanyi,'.');
                                                                writeln('       * Genre : ',ArrGenre[j].Genre);
                                                                writeln('       * Durasi : ',ArrGenre[j].Durasi.Jam,'h - ',ArrGenre[j].Durasi.Menit,'m - ',ArrGenre[j].Durasi.Detik,'s.');
                                                                writeln('       * Status Diputar : ',ArrGenre[j].Diputar);
                                                                writeln();
                                                        end
                                        until(i=ID);
                                        if(i=ID)then
                                                writeln('Tidak Ada Lagu Dengan Genre Ini Lagi');
                                end;
                        writeln();
                        if(ID=0)then
                                jumlah:=0;
                        writeln('** JUMLAH LAGU DALAM GENRE INI **',jumlah,' BUAH.');
                        writeln();
                        writeln('Tekan Apapun Untuk Melanjutkan');
                        readkey();
                        clrscr;
                end;

        //7. Menampilkan Lagu Pergenre Tertentu Berdasarkan Judul
        procedure MenampilkanDataLaguPer_GenreTertentuSecaraTerurutAlfabetBerdasarkanJudul(var ID:integer;var Lagu:array of KomponenLagu);
                var
                        ArrGenre:array[1..100]of KomponenLagu;
                        genre:string;
                begin
                        writeln('7. Menampilkan Lagu Per-Genre Tertentu Berdasarkan Judul');
                        writeln('===================================');
                        writeln('Masukan Genre diantara Art,Populer,dan Tradisional');
                        write('Genre : ');readln(genre);
                        writeln('===================================');
                        if(ID=0)then
                                writeln('Playlist Kosong')
                        else if(not CheckGenre(genre))then
                                writeln('Masukan Invalid : Genre Tidak Sesuai')
                        else if(CheckGenre(genre))then
                                begin
                                        UrutkanSesuaiGenreJudul(genre,ID,Lagu,ArrGenre);
                                end;
                        writeln();
                        writeln('Tekan Apapun Untuk Melanjutkan');
                        readkey();
                        clrscr;
                end;

        //8. Menampilkan Data Lagu Per-Genre Tertentu Secara Terurut Berdasarkan Durasi
        procedure MenampilkanDataLaguPer_GenreTertentuSecaraTerurutBerdasarkanDurasi(ID:integer;Lagu:array of KomponenLagu);
                var
                        genre:string;
                begin
                        writeln('8. Menampilkan Data Lagu Per-Genre Tertentu Secara Terurut Berdasarkan Durasi');
                        writeln('===================================');
                        writeln('Masukan Genre diantara Art,Populer,dan Tradisional');
                        write('Genre : ');readln(genre);
                        writeln('===================================');
                        if(ID=0)then
                                writeln('Playlist Kosong')
                        else if(not CheckGenre(genre))then
                                writeln('Masukan Invalid : Genre Tidak Sesuai')
                        else if(CheckGenre(genre))then
                                begin
                                        UrutkanSesuaiGenre(genre,ID,Lagu);
                                end;
                        writeln();
                        writeln('Tekan Apapun Untuk Melanjutkan');
                        readkey();
                        clrscr;
                end;

        //9. Menampilkan Jumlah Semua Lagu Yang Ada Di Playlist Dan Total Waktu Untuk Memutarnya
        procedure MenampilkanJumlahSemuaLaguYangAdaDiPlaylistDanTotalWaktuUntukMemutarnya(ID:integer;Lagu:array of KomponenLagu);
                var
                        i:integer;
                        jam,menit,detik:integer;
                        procedure setawal(i:integer);
                                begin
                                        jam:=Lagu[i].Durasi.Jam;
                                        menit:=Lagu[i].Durasi.Menit;
                                        detik:=Lagu[i].Durasi.Detik;
                                end;
                begin
                        writeln('9. Menampilkan Jumlah Semua Lagu Yang Ada Di Playlist Dan Total Waktu Untuk Memutarnya');
                        writeln('===================================');
                        i:=1;
                        if(ID>1)then
                        begin
                        Setawal(i);
                        repeat
                                i:=i+1;
                                jam:=jam+Lagu[i].Durasi.Jam;
                                menit:=menit+Lagu[i].Durasi.Menit;
                                detik:=detik+Lagu[i].Durasi.Detik;
                                if(detik>59)then
                                        begin
                                                detik:=0;
                                                menit:=menit+1;
                                        end;
                                if(menit>59)then
                                        begin
                                                menit:=0;
                                                jam:=jam+1;
                                        end;
                        until(i=ID);
                        writeln('Jumlah Lagu Dalam Playlist : ',ID);
                        writeln('Total Waktu Untuk Memutarnya : ',jam,'h ',menit,'m ',detik,'s ');
                        end
                        else if(ID=1)then
                                begin
                                        Setawal(i);
                                        writeln('Jumlah Lagu Dalam Playlist : ',ID);
                                        writeln('Total Waktu Untuk Memutarnya : ',jam,'h ',menit,'m ',detik,'s ');
                                end
                        else
                                writeln('Playlist Kosong');
                        writeln();
                        writeln('Tekan Apapun Untuk Melanjutkan');
                        readkey();
                        clrscr;
                end;

        //10.Menampilkan Semua Data Lagu Yang Ada Di Playlist Secara Terurut Alfabet Berdasarkan Judul
        procedure MenampilkanSemuaDataLaguYangAdaDiPlaylistSecaraTerurutAlfabetBerdasarkanJudul(ID:integer;Lagu:array of KomponenLagu);
                var
                        j,i:integer;
                begin
                        writeln('10.Menampilkan Semua Data Lagu Yang Ada Di Playlist Secara Terurut Alfabet Berdasarkan Judul');
                        writeln('===================================');
                        if(ID>1)then
                                begin
                                        i:=1;
                                        insertion(i,ID+1,Lagu);
                                        i:=0;
                                        tampilkan(i,ID,Lagu);
                                end
                        else if(ID=1)then
                                begin
                                        i:=0;
                                        tampilkan(i,ID,Lagu);
                                end
                        else
                                writeln('Playlist Kosong');
                        writeln();
                        writeln('Tekan Apapun Untuk Melanjutkan');
                        readkey();
                        clrscr;
                end;

        //11. Menampilkan Semua Data Lagu Yang Ada Di Playlist Secara Terurut Alfabet Berdasarkan Durasi(ID,Lagu);
        procedure MenampilkanSemuaDataLaguYangAdaDiPlaylistSecaraTerurutAlfabetBerdasarkanDurasi(ID:integer;Lagu:array of KomponenLagu);
                begin
                        writeln('11.Menampilkan Semua Data Lagu Yang Ada Di Playlist Secara Terurut Alfabet Berdasarkan Durasi');
                        writeln('===================================');
                        if(ID>0)then
                                UrutkanSesuaiDurasi(ID,Lagu)
                        else
                                writeln('PlayList Kosong');
                        writeln();
                        writeln('Tekan Apapun Untuk Melanjutkan');
                        readkey();
                        clrscr;
                end;

        //13.Mengoutputkan Data
        procedure Output(ID:integer;Lagu:array of KomponenLagu);
                var
                        i:integer;
                begin
                        i:=0;
                        writeln('13.Mengoutputkan Semua Data');
                        writeln('===================================');
                        tampilkan(i,ID,Lagu);
                        writeln();
                        writeln('Tekan Apapun Untuk Melanjutkan');
                        readkey();
                        clrscr;
                end;

        //menampilkan menu
        procedure Menu(var ID:integer;var Lagu:array of KomponenLagu);
                var
                        pilihan:string;
                begin
                        writeln('MENU PROGRAM PLAYLIST');
                        writeln('===================================');
                        writeln('1. Tambah Lagu');
                        writeln('2. Lewati Lagu');
                        writeln('3. Hapus Lagu');
                        writeln('4. Putar Lagu');
                        writeln('5. Menampilkan Data Satu Lagu Tertentu');
                        writeln('6. Menampilkan Jumlah Lagu Per-Genre Tertentu');
                        writeln('7. Menampilkan Data Lagu Per-Genre Tertentu Secara Terurut Alfabet Berdasarkan Judul');
                        writeln('8. Menampilkan Data Lagu Per-Genre Tertentu Secara Terurut Berdasarkan Durasi');
                        writeln('9. Menampilkan Jumlah Semua Lagu Yang Ada Di Playlist Dan Total Waktu Untuk Memutarnya');
                        writeln('10.Menampilkan Semua Data Lagu Yang Ada Di Playlist Secara Terurut Alfabet Berdasarkan Judul');
                        writeln('11.Menampilkan Semua Data Lagu Yang Ada Di Playlist Secara Terurut Alfabet Berdasarkan Durasi');
                        writeln('12.Exit');
                        writeln('13.Mengoutpukan Semua Data');
                        writeln('===================================');
                        write('Pilihan Anda : ');readln(pilihan);
                        clrscr;
                        case pilihan of
                                '1':TambahLagu(ID,Lagu);
                                '2':LewatiLagu(ID,Lagu);
                                '3':HapusLagu(ID,Lagu);
                                '4':PutarLagu(ID,Lagu);
                                '5':MenampilkanDataSatuLaguTertentu(ID,Lagu);
                                '6':MenampilkanJumlahLaguPer_GenreTertentu(ID,Lagu);
                                '7':MenampilkanDataLaguPer_GenreTertentuSecaraTerurutAlfabetBerdasarkanJudul(ID,Lagu);
                                '8':MenampilkanDataLaguPer_GenreTertentuSecaraTerurutBerdasarkanDurasi(ID,Lagu);
                                '9':MenampilkanJumlahSemuaLaguYangAdaDiPlaylistDanTotalWaktuUntukMemutarnya(ID,Lagu);
                                '10':MenampilkanSemuaDataLaguYangAdaDiPlaylistSecaraTerurutAlfabetBerdasarkanJudul(ID,Lagu);
                                '11':MenampilkanSemuaDataLaguYangAdaDiPlaylistSecaraTerurutAlfabetBerdasarkanDurasi(ID,Lagu);
                                '12':Exit:=true;
                                '13':Output(ID,Lagu);
                               else
                                        writeln('Masukan Invalid');
                        end;
                end;

//Kode Utama
begin
        ID:=0;
        Exit:=false;
        repeat
                Menu(ID,Lagu);
        until(Exit);
end.
