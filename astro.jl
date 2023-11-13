import Pkg
# Download and install these libraries:
# - GZip: work with .gz compressed files
# - Interpolations: create interpolating functions from discrete data
# - Plots: guess what?
for name in ["GZip", "Interpolations", "Plots"]
    Pkg.add(name)
end


using GZip 
using Interpolations
using DelimitedFiles
using Printf:@printf
using Plots
gr()

const k, h, c = 1.38e-23, 6.626e-34, 3e8
# Write \lambda and press <TAB> to get λ
λ(ν) = c / ν
b(ν, T) = (2h*ν^3 / c^2) / (exp(h*ν / (k*T)) - 1)

let ν = 0.5e13:1e13:1e15
    plt = plot(ν, b.(ν, 3800),
# il b. mi permette di calcolare la funzione in tanti punti diversi 
    label = "", xlabel = "Frequency [Hz]", ylabel = "Spectral radiance [W/sr/m²/Hz]")
    display(plt)
    sleep(40)
end

function C(ν0, bwidth, T, δν)
    fullnu = 0.5e13:δν:1e15  # [0, ∞)
    partialnu = (ν0 - bwidth/2):δν:(ν0 + bwidth/2)
    sum(b.(fullnu, T)) / sum(b.(partialnu, T))
end

ν0, bwidth, T = c / 2.2e-6, 2.28e13, 3800
for δν in [1e13, 1e12, 1e11, 1e10, 1e9, 1e8]
    @printf("δν = %.0e Hz, T = %.1f K, C = %.2f\n",
            δν, T, C(ν0, bwidth, T, δν))
end

