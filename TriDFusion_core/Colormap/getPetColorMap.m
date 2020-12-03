function aColormapPET = getPetColorMap()    
%function aColormapPET = getPetColorMap()
%Get MIP PET Metal Color Map.
%See TriDFuison.doc (or pdf) for more information about options.
%
%Note: option settings must fit on one line and can contain one semicolon at most.
%Options can be strings, cell arrays of strings, or numerical arrays.
%
%Author: Daniel Lafontaine, lafontad@mskcc.org
%
%Last specifications modified:
%
% Copyright 2020, Daniel Lafontaine, on behalf of the TriDFusion development team.
% 
% This file is part of The Triple Dimention Fusion (TriDFusion).
% 
% TriDFusion development has been led by:  Daniel Lafontaine
% 
% TriDFusion is distributed under the terms of the Lesser GNU Public License. 
% 
%     This version of TriDFusion is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
% 
% TriDFusion is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
% without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
% See the GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with TriDFusion.  If not, see <http://www.gnu.org/licenses/>.
aColormapPET = [
    0	0	0
    0	2	1
    0	4	3
    0	6	5
    0	8	7
    0	10	9
    0	12	11
    0	14	13
    0	16	15
    0	18	17
    0	20	19
    0	22	21
    0	24	23
    0	26	25
    0	28	27
    0	30	29
    0	32	31
    0	34	33
    0	36	35
    0	38	37
    0	40	39
    0	42	41
    0	44	43
    0	46	45
    0	48	47
    0	50	49
    0	52	51
    0	54	53
    0	56	55
    0	58	57
    0	60	59
    0	62	61
    0	65	63
    0	67	65
    0	69	67
    0	71	69
    0	73	71
    0	75	73
    0	77	75
    0	79	77
    0	81	79
    0	83	81
    0	85	83
    0	87	85
    0	89	87
    0	91	89
    0	93	91
    0	95	93
    0	97	95
    0	99	97
    0	101	99
    0	103	101
    0	105	103
    0	107	105
    0	109	107
    0	111	109
    0	113	111
    0	115	113
    0	117	115
    0	119	117
    0	121	119
    0	123	121
    0	125	123
    0	128	125
    1	126	127
    3	124	129
    5	122	131
    7	120	133
    9	118	135
    11	116	137
    13	114	139
    15	112	141
    17	110	143
    19	108	145
    21	106	147
    23	104	149
    25	102	151
    27	100	153
    29	98	155
    31	96	157
    33	94	159
    35	92	161
    37	90	163
    39	88	165
    41	86	167
    43	84	169
    45	82	171
    47	80	173
    49	78	175
    51	76	177
    53	74	179
    55	72	181
    57	70	183
    59	68	185
    61	66	187
    63	64	189
    65	63	191
    67	61	193
    69	59	195
    71	57	197
    73	55	199
    75	53	201
    77	51	203
    79	49	205
    81	47	207
    83	45	209
    85	43	211
    86	41	213
    88	39	215
    90	37	217
    92	35	219
    94	33	221
    96	31	223
    98	29	225
    100	27	227
    102	25	229
    104	23	231
    106	21	233
    108	19	235
    110	17	237
    112	15	239
    114	13	241
    116	11	243
    118	9	245
    120	7	247
    122	5	249
    124	3	251
    126	1	253
    128	0	255
    130	2	252
    132	4	248
    134	6	244
    136	8	240
    138	10	236
    140	12	232
    142	14	228
    144	16	224
    146	18	220
    148	20	216
    150	22	212
    152	24	208
    154	26	204
    156	28	200
    158	30	196
    160	32	192
    162	34	188
    164	36	184
    166	38	180
    168	40	176
    170	42	172
    171	44	168
    173	46	164
    175	48	160
    177	50	156
    179	52	152
    181	54	148
    183	56	144
    185	58	140
    187	60	136
    189	62	132
    191	64	128
    193	66	124
    195	68	120
    197	70	116
    199	72	112
    201	74	108
    203	76	104
    205	78	100
    207	80	96
    209	82	92
    211	84	88
    213	86	84
    215	88	80
    217	90	76
    219	92	72
    221	94	68
    223	96	64
    225	98	60
    227	100	56
    229	102	52
    231	104	48
    233	106	44
    235	108	40
    237	110	36
    239	112	32
    241	114	28
    243	116	24
    245	118	20
    247	120	16
    249	122	12
    251	124	8
    253	126	4
    255	128	0
    255	130	4
    255	132	8
    255	134	12
    255	136	16
    255	138	20
    255	140	24
    255	142	28
    255	144	32
    255	146	36
    255	148	40
    255	150	44
    255	152	48
    255	154	52
    255	156	56
    255	158	60
    255	160	64
    255	162	68
    255	164	72
    255	166	76
    255	168	80
    255	170	85
    255	172	89
    255	174	93
    255	176	97
    255	178	101
    255	180	105
    255	182	109
    255	184	113
    255	186	117
    255	188	121
    255	190	125
    255	192	129
    255	194	133
    255	196	137
    255	198	141
    255	200	145
    255	202	149
    255	204	153
    255	206	157
    255	208	161
    255	210	165
    255	212	170
    255	214	174
    255	216	178
    255	218	182
    255	220	186
    255	222	190
    255	224	194
    255	226	198
    255	228	202
    255	230	206
    255	232	210
    255	234	214
    255	236	218
    255	238	222
    255	240	226
    255	242	230
    255	244	234
    255	246	238
    255	248	242
    255	250	246
    255	252	250
    255	255	255
    ] / 255;
end

