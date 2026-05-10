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