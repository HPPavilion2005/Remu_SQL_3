USE Baitap03
GO

CREATE TABLE KhachHang (

    MaKH INT PRIMARY KEY IDENTITY(1,1),

    HoTen NVARCHAR(100),

    SoDienThoai VARCHAR(15),

    CCCD VARCHAR(20),

    DiaChi NVARCHAR(255)

);

CREATE TABLE HopDong (

    MaHD INT PRIMARY KEY IDENTITY(1,1),

    MaKH INT,

    NgayVay DATE,

    TienGoc DECIMAL(18,2),

    Deadline1 DATE,

    Deadline2 DATE,

    TrangThai NVARCHAR(50),

    FOREIGN KEY (MaKH)
        REFERENCES KhachHang(MaKH)

);

CREATE TABLE TaiSan (

    MaTS INT PRIMARY KEY IDENTITY(1,1),

    TenTaiSan NVARCHAR(100),

    GiaTriDinhGia DECIMAL(18,2),

    TrangThai NVARCHAR(50)

);

CREATE TABLE HopDong_TaiSan (

    MaHD INT,

    MaTS INT,

    PRIMARY KEY (MaHD, MaTS),

    FOREIGN KEY (MaHD)
        REFERENCES HopDong(MaHD),

    FOREIGN KEY (MaTS)
        REFERENCES TaiSan(MaTS)

);

CREATE TABLE ThanhToan (

    MaTT INT PRIMARY KEY IDENTITY(1,1),

    MaHD INT,

    NgayThanhToan DATE,

    SoTienTra DECIMAL(18,2),

    NguoiThu NVARCHAR(100),

    FOREIGN KEY (MaHD)
        REFERENCES HopDong(MaHD)

);

CREATE TABLE LichSuTrangThai (

    MaLS INT PRIMARY KEY IDENTITY(1,1),

    MaHD INT,

    TrangThaiCu NVARCHAR(50),

    TrangThaiMoi NVARCHAR(50),

    NgayDoi DATETIME DEFAULT GETDATE(),

    FOREIGN KEY (MaHD)
        REFERENCES HopDong(MaHD)

);

INSERT INTO KhachHang
(
    HoTen,
    SoDienThoai,
    CCCD,
    DiaChi
)
VALUES
(
    N'Nguyễn Văn A',
    '0988888888',
    '123456789',
    N'Hà Nội'
),
(
    N'Trần Thị B',
    '0977777777',
    '987654321',
    N'Hồ Chí Minh'
);

SELECT * FROM KhachHang;

INSERT INTO HopDong
(
    MaKH,
    NgayVay,
    TienGoc,
    Deadline1,
    Deadline2,
    TrangThai
)
VALUES
(
    1,
    '2026-05-01',
    10000000,
    '2026-05-10',
    '2026-05-20',
    N'Đang vay'
),
(
    2,
    '2026-05-03',
    5000000,
    '2026-05-12',
    '2026-05-22',
    N'Đang vay'
);

SELECT * FROM HopDong;

INSERT INTO TaiSan
(
    TenTaiSan,
    GiaTriDinhGia,
    TrangThai
)
VALUES
(
    N'iPhone 15',
    20000000,
    N'Đang giữ'
),
(
    N'MacBook Pro',
    30000000,
    N'Đang giữ'
),
(
    N'Xe Vision',
    25000000,
    N'Đang giữ'
);

SELECT * FROM TaiSan;

INSERT INTO HopDong_TaiSan
(
    MaHD,
    MaTS
)
VALUES
(1,1),
(1,2),
(2,3);

INSERT INTO ThanhToan
(
    MaHD,
    NgayThanhToan,
    SoTienTra,
    NguoiThu
)
VALUES
(
    1,
    '2026-05-05',
    2000000,
    N'Nhân viên A'
),
(
    1,
    '2026-05-07',
    1000000,
    N'Nhân viên B'
);

INSERT INTO LichSuTrangThai
(
    MaHD,
    TrangThaiCu,
    TrangThaiMoi
)
VALUES
(
    1,
    N'Đang vay',
    N'Đang trả góp'
);

SELECT * FROM KhachHang;
SELECT * FROM HopDong;
SELECT * FROM TaiSan;
GO

CREATE PROCEDURE sp_CreateContract
(
    @HoTen NVARCHAR(100),
    @SoDienThoai VARCHAR(15),
    @CCCD VARCHAR(20),
    @DiaChi NVARCHAR(255),

    @TenTaiSan NVARCHAR(100),
    @GiaTriDinhGia DECIMAL(18,2),

    @TienGoc DECIMAL(18,2),
    @NgayVay DATE
)
AS
BEGIN

    --------------------------------
    -- 1. Thêm khách hàng
    --------------------------------

    INSERT INTO KhachHang
    (
        HoTen,
        SoDienThoai,
        CCCD,
        DiaChi
    )
    VALUES
    (
        @HoTen,
        @SoDienThoai,
        @CCCD,
        @DiaChi
    );

    DECLARE @MaKH INT;

    SET @MaKH = SCOPE_IDENTITY();

    --------------------------------
    -- 2. Tạo hợp đồng
    --------------------------------

    DECLARE @Deadline1 DATE;
    DECLARE @Deadline2 DATE;

    SET @Deadline1 =
        DATEADD(DAY, 10, @NgayVay);

    SET @Deadline2 =
        DATEADD(DAY, 20, @NgayVay);

    INSERT INTO HopDong
    (
        MaKH,
        NgayVay,
        TienGoc,
        Deadline1,
        Deadline2,
        TrangThai
    )
    VALUES
    (
        @MaKH,
        @NgayVay,
        @TienGoc,
        @Deadline1,
        @Deadline2,
        N'Đang vay'
    );

    DECLARE @MaHD INT;

    SET @MaHD = SCOPE_IDENTITY();

    --------------------------------
    -- 3. Thêm tài sản
    --------------------------------

    INSERT INTO TaiSan
    (
        TenTaiSan,
        GiaTriDinhGia,
        TrangThai
    )
    VALUES
    (
        @TenTaiSan,
        @GiaTriDinhGia,
        N'Đang giữ'
    );

    DECLARE @MaTS INT;

    SET @MaTS = SCOPE_IDENTITY();

    --------------------------------
    -- 4. Gắn tài sản vào hợp đồng
    --------------------------------

    INSERT INTO HopDong_TaiSan
    (
        MaHD,
        MaTS
    )
    VALUES
    (
        @MaHD,
        @MaTS
    );

END;
GO

EXEC sp_CreateContract

    @HoTen = N'Nguyễn Văn C',
    @SoDienThoai = '0911111111',
    @CCCD = '123123123',
    @DiaChi = N'Hà Nội',

    @TenTaiSan = N'iPhone 16',
    @GiaTriDinhGia = 25000000,

    @TienGoc = 10000000,
    @NgayVay = '2026-05-08';

SELECT * FROM KhachHang;
SELECT * FROM HopDong;
SELECT * FROM TaiSan;
SELECT * FROM HopDong_TaiSan;
GO

CREATE FUNCTION fn_CalcMoneyTransaction
(
    @TransactionID INT,
    @TargetDate DATE
)
RETURNS DECIMAL(18,2)
AS
BEGIN

    DECLARE @TienGoc DECIMAL(18,2);
    DECLARE @NgayVay DATE;
    DECLARE @Deadline1 DATE;

    DECLARE @TongNo DECIMAL(18,2);

    SELECT
        @TienGoc = TienGoc,
        @NgayVay = NgayVay,
        @Deadline1 = Deadline1
    FROM HopDong
    WHERE MaHD = @TransactionID;

    IF @TargetDate <= @Deadline1
    BEGIN

        DECLARE @SoNgay INT;

        SET @SoNgay =
            DATEDIFF(DAY, @NgayVay, @TargetDate);

        SET @TongNo =
            @TienGoc +
            (@TienGoc * 0.005 * @SoNgay);

    END

    ELSE
    BEGIN

        DECLARE @NgayLaiDon INT;

        SET @NgayLaiDon =
            DATEDIFF(DAY, @NgayVay, @Deadline1);

        DECLARE @TienSauLaiDon DECIMAL(18,2);

        SET @TienSauLaiDon =
            @TienGoc +
            (@TienGoc * 0.005 * @NgayLaiDon);

        DECLARE @NgayQuaHan INT;

        SET @NgayQuaHan =
            DATEDIFF(DAY, @Deadline1, @TargetDate);

        SET @TongNo =
            @TienSauLaiDon *
            POWER(1.005, @NgayQuaHan);

    END

    RETURN @TongNo;

END;
GO

CREATE FUNCTION fn_CalcMoneyContract
(
    @ContractID INT,
    @TargetDate DATE
)
RETURNS DECIMAL(18,2)
AS
BEGIN

    DECLARE @TongTien DECIMAL(18,2);

    SET @TongTien =
        dbo.fn_CalcMoneyTransaction
        (
            @ContractID,
            @TargetDate
        );

    RETURN @TongTien;

END;
GO

ALTER TABLE TaiSan
ADD IsSold BIT DEFAULT 0;
GO

ALTER TABLE ThanhToan
ADD SoTienConNo DECIMAL(18,2);
GO

CREATE PROCEDURE sp_PayDebt
(
    @MaHD INT,
    @SoTienTra DECIMAL(18,2),
    @NguoiThu NVARCHAR(100)
)
AS
BEGIN

    --------------------------------
    -- 1. Kiểm tra tài sản thanh lý
    --------------------------------

    IF EXISTS
    (
        SELECT 1
        FROM HopDong_TaiSan HDTS

        JOIN TaiSan TS
            ON HDTS.MaTS = TS.MaTS

        WHERE HDTS.MaHD = @MaHD
        AND TS.IsSold = 1
    )
    BEGIN

        PRINT N'Tài sản đã thanh lý. Không thể thu tiền hoặc trả đồ.';
        RETURN;

    END

    --------------------------------
    -- 2. Tính tổng nợ
    --------------------------------

    DECLARE @TongNo DECIMAL(18,2);

    SET @TongNo =
        dbo.fn_CalcMoneyContract
        (
            @MaHD,
            GETDATE()
        );

    --------------------------------
    -- 3. Tính tiền còn nợ
    --------------------------------

    DECLARE @ConNo DECIMAL(18,2);

    SET @ConNo =
        @TongNo - @SoTienTra;

    --------------------------------
    -- 4. Ghi log thanh toán
    --------------------------------

    INSERT INTO ThanhToan
    (
        MaHD,
        NgayThanhToan,
        SoTienTra,
        NguoiThu,
        SoTienConNo
    )
    VALUES
    (
        @MaHD,
        GETDATE(),
        @SoTienTra,
        @NguoiThu,
        @ConNo
    );

    --------------------------------
    -- 5. Nếu trả đủ
    --------------------------------

    IF @ConNo <= 0
    BEGIN

        UPDATE HopDong
        SET TrangThai =
            N'Đã thanh toán đủ'
        WHERE MaHD = @MaHD;

        UPDATE TaiSan
        SET TrangThai =
            N'Đã trả khách'
        WHERE MaTS IN
        (
            SELECT MaTS
            FROM HopDong_TaiSan
            WHERE MaHD = @MaHD
        );

        PRINT N'Khách đã trả đủ tiền. Hoàn trả tài sản.';

    END

    --------------------------------
    -- 6. Nếu chưa trả đủ
    --------------------------------

    ELSE
    BEGIN

        UPDATE HopDong
        SET TrangThai =
            N'Đang trả góp'
        WHERE MaHD = @MaHD;

        PRINT N'Khách chưa trả đủ. Đã cập nhật trả góp.';

    END

    --------------------------------
    -- 7. Gợi ý tài sản có thể trả
    --------------------------------

    PRINT N'Danh sách tài sản có thể trả:';

    SELECT
        TS.MaTS,
        TS.TenTaiSan,
        TS.GiaTriDinhGia
    FROM TaiSan TS

    JOIN HopDong_TaiSan HDTS
        ON TS.MaTS = HDTS.MaTS

    WHERE HDTS.MaHD = @MaHD
    AND TS.GiaTriDinhGia >= @ConNo;

END;
GO

DROP FUNCTION IF EXISTS fn_SoNgayQuaHan;
GO

CREATE FUNCTION fn_SoNgayQuaHan
(
    @MaHD INT
)
RETURNS INT
AS
BEGIN

    DECLARE @SoNgay INT;

    SELECT
        @SoNgay =
            DATEDIFF
            (
                DAY,
                Deadline1,
                GETDATE()
            )
    FROM HopDong
    WHERE MaHD = @MaHD;

    RETURN @SoNgay;

END;
GO

SELECT

    KH.HoTen,
    KH.SoDienThoai,

    HD.TienGoc,

    dbo.fn_SoNgayQuaHan
    (
        HD.MaHD
    ) AS SoNgayQuaHan,

    dbo.fn_CalcMoneyContract
    (
        HD.MaHD,
        GETDATE()
    ) AS TongNoHienTai,

    dbo.fn_CalcMoneyContract
    (
        HD.MaHD,
        DATEADD(MONTH, 1, GETDATE())
    ) AS TongNoSau1Thang

FROM HopDong HD

JOIN KhachHang KH
    ON HD.MaKH = KH.MaKH

WHERE
    GETDATE() > HD.Deadline1

AND
    HD.TrangThai != N'Đã thanh toán đủ';

DROP TRIGGER IF EXISTS trg_BadDebt;
GO

CREATE TRIGGER trg_BadDebt
ON HopDong
AFTER INSERT, UPDATE
AS
BEGIN

    UPDATE HopDong
    SET TrangThai =
        N'Quá hạn (nợ xấu)'

    WHERE
        TrangThai = N'Đang vay'

    AND
        GETDATE() > Deadline1;

END;
GO

DROP TRIGGER IF EXISTS trg_ReadyToSell;
GO

CREATE TRIGGER trg_ReadyToSell
ON HopDong
AFTER UPDATE
AS
BEGIN

    UPDATE TaiSan
    SET TrangThai =
        N'Sẵn sàng thanh lý'

    WHERE MaTS IN
    (
        SELECT HDTS.MaTS

        FROM HopDong_TaiSan HDTS

        JOIN HopDong HD
            ON HDTS.MaHD = HD.MaHD

        WHERE
            HD.TrangThai =
                N'Quá hạn (nợ xấu)'

        AND
            GETDATE() > HD.Deadline2
    );

END;
GO

DROP TRIGGER IF EXISTS trg_SoldAsset;
GO

CREATE TRIGGER trg_SoldAsset
ON HopDong
AFTER UPDATE
AS
BEGIN

    UPDATE TaiSan
    SET
        TrangThai =
            N'Đã bán thanh lý',

        IsSold = 1

    WHERE MaTS IN
    (
        SELECT HDTS.MaTS

        FROM HopDong_TaiSan HDTS

        JOIN inserted i
            ON HDTS.MaHD = i.MaHD

        WHERE
            i.TrangThai =
                N'Đã thanh lý'
    );

END;
GO

DROP PROCEDURE IF EXISTS sp_ExtendContract;
GO

CREATE PROCEDURE sp_ExtendContract
(
    @MaHD INT,
    @TienTra DECIMAL(18,2)
)
AS
BEGIN

    --------------------------------
    -- 1. Lấy thông tin hợp đồng
    --------------------------------

    DECLARE @TienGoc DECIMAL(18,2);
    DECLARE @NgayVay DATE;

    SELECT
        @TienGoc = TienGoc,
        @NgayVay = NgayVay
    FROM HopDong
    WHERE MaHD = @MaHD;

    --------------------------------
    -- 2. Tính tiền lãi hiện tại
    --------------------------------

    DECLARE @TongNo DECIMAL(18,2);

    SET @TongNo =
        dbo.fn_CalcMoneyContract
        (
            @MaHD,
            GETDATE()
        );

    DECLARE @TienLai DECIMAL(18,2);

    SET @TienLai =
        @TongNo - @TienGoc;

    --------------------------------
    -- 3. Kiểm tra khách trả đủ lãi chưa
    --------------------------------

    IF @TienTra >= @TienLai
    BEGIN

        --------------------------------
        -- Gia hạn deadline
        --------------------------------

        UPDATE HopDong
        SET
            Deadline1 =
                DATEADD(DAY, 10, GETDATE()),

            Deadline2 =
                DATEADD(DAY, 20, GETDATE()),

            TrangThai =
                N'Đã gia hạn'

        WHERE MaHD = @MaHD;

        --------------------------------
        -- Ghi log
        --------------------------------

        INSERT INTO ThanhToan
        (
            MaHD,
            NgayThanhToan,
            SoTienTra,
            NguoiThu,
            SoTienConNo
        )
        VALUES
        (
            @MaHD,
            GETDATE(),
            @TienTra,
            N'Gia hạn hợp đồng',
            @TienGoc
        );

        PRINT N'Gia hạn hợp đồng thành công.';

    END

    ELSE
    BEGIN

        PRINT N'Khách chưa trả đủ tiền lãi để gia hạn.';

    END

END;
GO