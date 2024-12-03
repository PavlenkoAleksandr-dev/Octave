% Лабораторная работа №3: Свойства Дискретного Преобразования Фурье (ДПФ)
% Генерация случайного сигнала и его обработка

pkg load signal;

% 1. Параметры сигнала
Fs = 1000; % Частота дискретизации, Гц
T = 10;    % Длительность сигнала, с
N = Fs * T; % Количество точек
t = (0:N-1) / Fs; % Временной вектор

% Генерация случайного сигнала
f1 = randi([1, 10]); % Случайная частота 1, Гц
f2 = randi([1, 10]); % Случайная частота 2, Гц
signal = sin(2 * pi * f1 * t) + 0.5 * sin(2 * pi * f2 * t); % Сумма двух синусов с разными частотами

% Применение окна Ханна
window = hann(N)'; % Ханново окно
signal_windowed = signal .* window;

% 2. Расчет спектров
f = (0:N-1) * Fs / N; % Частоты
spectrum_original = abs(fft(signal)) / (N / 2);
spectrum_windowed = abs(fft(signal_windowed)) / (N / 2);

% Выбор половины спектра
spectrum_original = spectrum_original(1:N/2);
spectrum_windowed = spectrum_windowed(1:N/2);
f = f(1:N/2);

% 3. Построение графиков
figure;

% 1. Исходный сигнал с окном
subplot(3, 2, 1);
plot(t, signal, 'r', t, signal_windowed, 'b', t, window, 'k', 'LineWidth', 1);
title('Signal');
xlabel('time, [s]');
ylabel('Amplitude');
legend('Original Signal', 'Windowed Signal', 'Hann Window');
grid on;

% 2. Логарифмический спектр исходного сигнала
subplot(3, 2, 2);
stem(f, spectrum_original, 'r', 'LineWidth', 1);
title('The spectr of original signal');
xlabel('frequency, [Hz]');
ylabel('Amplitude');
set(gca, 'YScale', 'log'); % Логарифмическая шкала
grid on;

% 3. Линейный спектр исходного сигнала
subplot(3, 2, 3);
plot(f, spectrum_original, 'r', 'LineWidth', 1);
hold on;
[max_val1, idx1] = max(spectrum_original); % Пик спектра
plot(f(idx1), max_val1, 'go', 'LineWidth', 1.5);
title('Zoomed spectrum (original)');
xlabel('frequency, [Hz]');
ylabel('Amplitude');
xlim([f1-1, f1+1]); % Увеличение участка вокруг первой частоты
grid on;

% 4. Логарифмический спектр оконного сигнала
subplot(3, 2, 4);
stem(f, spectrum_windowed, 'b', 'LineWidth', 1);
title('The spectr of transformed signal');
xlabel('frequency, [Hz]');
ylabel('Amplitude');
set(gca, 'YScale', 'log'); % Логарифмическая шкала
grid on;

% 5. Линейный спектр оконного сигнала
subplot(3, 2, 5);
plot(f, spectrum_windowed, 'b', 'LineWidth', 1);
hold on;
[max_val2, idx2] = max(spectrum_windowed); % Пик спектра
plot(f(idx2), max_val2, 'go', 'LineWidth', 1.5);
title('Zoomed spectrum (transformed)');
xlabel('frequency, [Hz]');
ylabel('Amplitude');
xlim([f2-1, f2+1]); % Увеличение участка вокруг второй частоты
grid on;

% Убираем лишний график
subplot(3, 2, 6);
axis off;

