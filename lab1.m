% Параметры
T = 2 * pi; % Период
t = linspace(-T, T, 1000); % Временной интервал
A = 1; % Амплитуда
N_max = 10; % Максимальное число гармоник для аппроксимации

% --- 1. Аналитическое представление сигналов ---

% Прямоугольный сигнал
S_rect = A * sign(sin(2 * pi * t / T));

% Пилообразный сигнал
S_saw = 2 * A / pi * (t - T * floor(t / T + 0.5));

% Треугольный сигнал
S_tri = A * (2 * abs(2 * (t / T - floor(t / T + 0.5))) - 1);

% --- 2. Фурье-аппроксимация сигналов ---

% Функция для вычисления Фурье-аппроксимации
function S_app = fourier_approx(t, T, N, signal_type)
    S_app = zeros(size(t));
    if strcmp(signal_type, 'rect')
        for k = 1:N
            S_app += (4 / (pi * (2 * k - 1))) * sin((2 * k - 1) * 2 * pi * t / T);
        end
    elseif strcmp(signal_type, 'saw')
        for k = 1:N
            S_app += (2 * (-1)^(k+1) * sin(k * 2 * pi * t / T)) / (k * pi);
        end
    elseif strcmp(signal_type, 'tri')
        for k = 1:N
            S_app += (8 / (pi^2 * (2 * k - 1)^2)) * cos((2 * k - 1) * 2 * pi * t / T);
        end
    end
end

% Графики сигналов и их аппроксимаций
figure;
subplot(3, 1, 1);
plot(t, S_rect, 'b', 'DisplayName', 'Прямоугольный сигнал'); hold on;
plot(t, fourier_approx(t, T, 10, 'rect'), 'r--', 'DisplayName', 'Аппроксимация 10 гармоник');
title('Прямоугольный сигнал и его Фурье-аппроксимация');
legend;
xlabel('Время'); ylabel('Амплитуда');

subplot(3, 1, 2);
plot(t, S_saw, 'b', 'DisplayName', 'Пилообразный сигнал'); hold on;
plot(t, fourier_approx(t, T, 10, 'saw'), 'r--', 'DisplayName', 'Аппроксимация 10 гармоник');
title('Пилообразный сигнал и его Фурье-аппроксимация');
legend;
xlabel('Время'); ylabel('Амплитуда');

subplot(3, 1, 3);
plot(t, S_tri, 'b', 'DisplayName', 'Треугольный сигнал'); hold on;
plot(t, fourier_approx(t, T, 10, 'tri'), 'r--', 'DisplayName', 'Аппроксимация 10 гармоник');
title('Треугольный сигнал и его Фурье-аппроксимация');
legend;
xlabel('Время'); ylabel('Амплитуда');

% --- 3. Оценка качества аппроксимации ---

STD_values_rect = zeros(1, N_max);
STD_values_saw = zeros(1, N_max);
STD_values_tri = zeros(1, N_max);

for n = 1:N_max
    % Прямоугольный сигнал
    S_app_rect = fourier_approx(t, T, n, 'rect');
    STD_values_rect(n) = sqrt(mean((S_rect - S_app_rect).^2));

    % Пилообразный сигнал
    S_app_saw = fourier_approx(t, T, n, 'saw');
    STD_values_saw(n) = sqrt(mean((S_saw - S_app_saw).^2));

    % Треугольный сигнал
    S_app_tri = fourier_approx(t, T, n, 'tri');
    STD_values_tri(n) = sqrt(mean((S_tri - S_app_tri).^2));
end

% График STD(n) для каждого сигнала
figure;
plot(1:N_max, STD_values_rect, '-o', 'DisplayName', 'Прямоугольный сигнал'); hold on;
plot(1:N_max, STD_values_saw, '-o', 'DisplayName', 'Пилообразный сигнал');
plot(1:N_max, STD_values_tri, '-o', 'DisplayName', 'Треугольный сигнал');
title('Зависимость STD(n) от числа гармоник n');
xlabel('Число гармоник n'); ylabel('STD(n)');
legend;

