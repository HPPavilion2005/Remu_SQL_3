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